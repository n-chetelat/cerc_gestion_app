  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { mapGetters, mapActions } from "vuex"
import { groupBy } from "lodash-es"

import ServerErrorModal from "./boards/modals/server-error.vue"
import MilestoneCell from "./timeline/milestone-cell.vue"
import AdminNav from "components/shared/admin-nav.vue"
import ProfileMilestonesModal from "./timeline/modals/profile-milestones.vue"

  export default {
    name: "Timeline",
    mixins: [SceneMixin, ModalMixin],
    async created() {
      try {
        await this.fetchActiveProfileTimelineDates()
        await Promise.all([
          this.fetchMilestones(), this.fetchProfiles(),
          this.getAllPositions(), this.fetchProfileFields(),
          this.fetchMonths(), this.fetchSemesters()
        ])
        await this.fetchPersonMilestones()
      } catch (err) {
        this.openModal("server-error", {})
      }
    },
    updated() {
      const timelineTable = document.querySelector(".timeline-table")
      const currentHeader = document.querySelector("th.--current")
      if (timelineTable && currentHeader) {
        timelineTable.scrollBy(-(timelineTable.scrollWidth), 0)
        timelineTable.scrollBy(currentHeader.offsetLeft, 0)
      }
    },
    data() {
      return {
        currentProfileInModal: null,
        currentTabInModal: null,
      }
    },
    computed: {
      ...mapGetters("milestones", ["milestonesById", "milestonesByPersonId"]),
      ...mapGetters("profiles", ["profiles"]),
      ...mapGetters("dates", ["timelineDates"]),
      ...mapGetters("positions", ["allPositionsById"]),
      currentDate() {
        const today = new Date
        const month = `${today.getMonth() + 1}`.padStart(2, "0")
        const date = `${today.getFullYear()}-${month}-01`
        return date
      },
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
        return (this.profiles.length + 1) * cellMaxHeight + headerHeight
      }
    },
    methods: {
      ...mapActions("milestones", ["fetchMilestones", "fetchPersonMilestones"]),
      ...mapActions("profiles", ["fetchProfiles", "fetchProfileFields"]),
      ...mapActions("dates", ["fetchSemesters", "fetchMonths", "fetchActiveProfileTimelineDates"]),
      ...mapActions("positions", ["getAllPositions"]),
      openModalByName(modalName, data={}) {
        if (modalName === "profile-milestones") {
          this.currentProfileInModal = data.profile
          this.currentTabInModal = data.tab
        }
        this.openModal(modalName)
      },
      closeModal() {
        this.modalVisible = false
        this.modalName = null
        if (this.currentProfileInModal) this.currentProfileInModal = null
      },
      isCurrentSemester(semester) {
        const dates = [semester.id, ...semester.months.map(m => m.id)]
        return dates.includes(this.currentDate)
      },
      milestonesForSemester(profile, semester) {
        if (!this.milestonesBySemester[profile.uuid]) return null
        return this.milestonesBySemester[profile.uuid][semester.id]
      },
    },
    components: {
      ServerErrorModal,
      MilestoneCell,
      AdminNav,
      ProfileMilestonesModal
    }
  }
  </script>

  <template lang="pug">
    div.timeline
      server-error-modal(@close="closeModal", v-if="modalVisible && modalName === 'server-error'")
      profile-milestones-modal(@close="closeModal", v-if="modalVisible && modalName === 'profile-milestones'", :profile="currentProfileInModal", :tab="currentTabInModal")

      admin-nav

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
                  div.cell-content(@click="openModalByName('profile-milestones', { profile })") {{profile.full_name}}
                    div.person-position-label {{allPositionsById[profile.position_id].title}}

        div.dynamic-table.timeline-table(:style="{minHeight: `${timelineTableMinHeight}px`}")
          table
            thead
              tr
                th(v-for="date in timelineDates", :class="{'--current': isCurrentSemester(date)}")
                  div.header-content
                    p {{date.label}}
                    span.months-label {{date.months[0].label}} - {{date.months[date.months.length-1].label}}
            tbody
              tr(v-for="profile in profiles")
                td(v-for="semester in timelineDates", :class="{'--current': isCurrentSemester(semester)}")
                  milestone-cell.cell-content(
                    :profile="profile",
                    :person-milestones="milestonesForSemester(profile, semester)",
                    :semester="semester",
                    @error="openModalByName('server-error')"
                    @modal="openModalByName('profile-milestones', { profile, tab: 'milestones' })")

  </template>

  <style>

  @import "../init/variables.css";

  :root {
    --cellMaxHeight: 62;
  }

  .timeline {
    display: flex;
    flex-direction: column;
    flex-wrap: nowrap;
    height: 100%;

    & .tables {
      width: 100%;
    }

    & .timeline-table {
      transform: translate(var(--cellWidth)em, 0);
      width: calc(100% - var(--cellWidth)em);

      & th.--current, td.--current {
        background-color: color(var(--themeColor) alpha(20%));
      }
    }

    & .cell-content {
      cursor: pointer;
    }

    & .cell-content, .header-content {
      min-width: var(--cellWidth)em;
      max-width: var(--cellWidth)em;
      min-height: var(--cellMinHeight)px;
      max-height: var(--cellMaxHeight)px;

      & .person-position-label {
        font-size: .8em;
      }
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
