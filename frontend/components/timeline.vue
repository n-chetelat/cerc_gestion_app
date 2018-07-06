  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { mapGetters, mapActions } from "vuex"

import ServerErrorModal from "./boards/modals/server-error.vue"

  export default {
    name: "Timeline",
    mixins: [SceneMixin, ModalMixin],
    async created() {
      try {
        await this.fetchActiveProfileTimelineDates()
        await Promise.all([
          this.fetchMilestones(), this.fetchProfiles()
        ])
      } catch (err) {
        this.openModal("server-error", {})
      }
    },
    data() {
      return {

      }
    },
    computed: {
      ...mapGetters("milestones", ["milestonesById"]),
      ...mapGetters("profiles", ["profiles", "fields"]),
      ...mapGetters("dates", ["timelineDates"]),
    },
    methods: {
      ...mapActions("milestones", ["fetchMilestones"]),
      ...mapActions("profiles", ["fetchProfiles"]),
      ...mapActions("dates", ["fetchActiveProfileTimelineDates"]),
      openModalByName(modalName, data={}) {
        this.openModal(modalName)
      },
    },
    components: {
      ServerErrorModal
    }
  }
  </script>

  <template lang="pug">
    div.timeline
      server-error-modal(@close="closeModal", v-if="modalVisible && modalName === 'server-error'")
      new-profile-modal(@close="closeModal", v-if="modalVisible && modalName === 'new-profile'", @error="openModalByName('server-error')")

      div.tables
        table.table.names-table
          thead
            tr
              th
                div.header-content -
            tr
              th Name
          tbody
            tr(v-for="profile in profiles")
              td {{profile.full_name}}

        table.table.dynamic-table.timeline-table
          thead
            tr
              th(v-for="date in timelineDates", :colspan="date.months.length")
                div.header-content
                  p {{date.label}}
                  p.months-label {{date.months[0].label}} - {{date.months[date.months.length-1].label}}
          tbody
            tr(v-for="profile in profiles")
              td hi
              td there
              td all
              td 5


  </template>

  <style>

  @import "../init/variables.css";

  .timeline {
    display: flex;
    flex-wrap: nowrap;
    height: 100%;

    & .timeline-table {
      transform: translate(var(--nameCellWidth)em, 0);
    }

    & .header-content {
      height: 100px;
    }

    & .months-label {
      display: inline-block;
      font-size: .7em;
    }

  }

  </style>
