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
    },
    methods: {
      ...mapActions("milestones", ["fetchMilestones"]),
      ...mapActions("profiles", ["fetchProfiles"]),
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
  </template>

  <style>

  @import "../init/variables.css";

  .timeline {
    display: flex;
    flex-wrap: nowrap;
    height: 100%;

  }

  </style>
