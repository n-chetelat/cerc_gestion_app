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
      } catch (err) {
        this.openModal("server-error", {})
      }
    },
    data() {
      return {
      }
    },
    computed: {
    },
    methods: {
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
