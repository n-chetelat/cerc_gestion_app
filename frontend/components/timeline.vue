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
        await this.fetchActiveProfileInterval()
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
      ...mapGetters("dates", ["interval"]),
    },
    methods: {
      ...mapActions("milestones", ["fetchMilestones"]),
      ...mapActions("profiles", ["fetchProfiles"]),
      ...mapActions("dates", ["fetchActiveProfileInterval"]),
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
              th Name
          tbody
            tr(v-for="profile in profiles")
              td {{profile.full_name}}

        table.table.dynamic-table.timeline-table
          thead
            tr
              th HI label
          tbody
            tr(v-for="profile in profiles")
              td hi


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
  }

  </style>
