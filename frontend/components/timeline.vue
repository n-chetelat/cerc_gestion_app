  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { mapGetters, mapActions } from "vuex"
import { groupBy } from "lodash-es"

import ServerErrorModal from "./boards/modals/server-error.vue"
import MilestoneCell from "./timeline/milestone-cell.vue"

  export default {
    name: "Timeline",
    mixins: [SceneMixin, ModalMixin],
    async created() {
      try {
        await this.fetchActiveProfileTimelineDates()
        await Promise.all([
          this.fetchMilestones(), this.fetchProfiles()
        ])
        await this.fetchPersonMilestones()
      } catch (err) {
        this.openModal("server-error", {})
      }
    },
    data() {
      return {

      }
    },
    computed: {
      ...mapGetters("milestones", ["milestonesById", "milestonesByPersonId"]),
      ...mapGetters("profiles", ["profiles", "fields"]),
      ...mapGetters("dates", ["timelineDates"]),
      milestonesBySemester() {
        const structure = {}
        this.profiles.forEach((profile) => {
          structure[profile.uuid] = groupBy(this.milestonesByPersonId[profile.uuid], (m) => m.date)
        })
        return structure
      },
      timelineTableMinHeight() {
        const cellMaxHeight = 62
        const headerHeight = 122
        return this.profiles.length * cellMaxHeight + headerHeight
      }
    },
    methods: {
      ...mapActions("milestones", ["fetchMilestones", "fetchPersonMilestones"]),
      ...mapActions("profiles", ["fetchProfiles"]),
      ...mapActions("dates", ["fetchActiveProfileTimelineDates"]),
      openModalByName(modalName, data={}) {
        this.openModal(modalName)
      },
      milestonesForSemester(profile, semester) {
        if (!this.milestonesBySemester[profile.uuid]) return null
        return this.milestonesBySemester[profile.uuid][semester.id]
      },
    },
    components: {
      ServerErrorModal,
      MilestoneCell
    }
  }
  </script>

  <template lang="pug">
    div.timeline
      server-error-modal(@close="closeModal", v-if="modalVisible && modalName === 'server-error'")

      div.tables
        div.names-table
          table
            thead
              tr
                th
                  div.header-content Name
            tbody
              tr(v-for="profile in profiles")
                td
                  div.cell-content {{profile.full_name}}

        div.dynamic-table.timeline-table(:style="{minHeight: `${timelineTableMinHeight}px`}")
          table
            thead
              tr
                th(v-for="date in timelineDates")
                  div.header-content
                    p {{date.label}}
                    span.months-label {{date.months[0].label}} - {{date.months[date.months.length-1].label}}
            tbody
              tr(v-for="profile in profiles")
                td(v-for="semester in timelineDates")
                  milestone-cell.cell-content(:person-milestones="milestonesForSemester(profile, semester)", :semester="semester")

  </template>

  <style>

  @import "../init/variables.css";

  :root {
    --cellMaxHeight: 62;
  }

  .timeline {
    display: flex;
    flex-wrap: nowrap;
    height: 100%;

    & .tables {
      width: 100%;
    }

    & .timeline-table {
      transform: translate(var(--cellWidth)em, 0);
      width: calc(100% - var(--cellWidth)em);
    }

    & .cell-content, .header-content {
      min-width: var(--cellWidth)em;
      max-width: var(--cellWidth)em;
      min-height: var(--cellMinHeight)px;
      max-height: var(--cellMaxHeight)px;
    }

    & .header-content {
      height: 100px;
      overflow: hidden;
      max-height: 100%;
    }


    & .months-label {
      display: inline-block;
      font-size: .7em;
    }

  }

  </style>
