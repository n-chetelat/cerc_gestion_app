  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { mapGetters, mapActions } from "vuex"

import Phase from "./boards/phase.vue"
import PersonInfoModal from "./boards/modals/person-info.vue"
import BoardSidebar from "./boards/board-sidebar.vue"

  export default {
    name: "Board",
    mixins: [SceneMixin, ModalMixin],
    props: {
      boardSlug: {
        required: true
      }
    },
    async created() {
      await this.fetchBoard(this.boardSlug)
    },
    data() {
      return {
        phasesScrollX: 0,
        scrollInterval: 300,
        maxScrollX: 0,
        person: null,
        tab: null,
      }
    },
    computed: {
      ...mapGetters("boards", ["currentBoard", "nonFinalPhases", "finalPhases"]),
      isLoaded() {
        return !!(this.loaded && this.currentBoard)
      },
      minScrollX() {
        const phases = document.querySelector(".phases-wrapper")
        return -(phases.offsetWidth)
      },
    },
    methods: {
      ...mapActions("boards", ["fetchBoard"]),
      openModalByName(modalName, data) {
        if (modalName === "person-info") {
          this.person = data.person
          this.tab = data.tab
        }
        this.openModal(modalName)
      }
    },
    components: {
      Phase,
      PersonInfoModal,
      BoardSidebar
    }
  }
  </script>

  <template lang="pug">
    div.boards(v-if="isLoaded")
      person-info-modal(@close="closeModal", v-if="modalVisible && modalName === 'person-info'", :person="person", :tab="tab")

      div.phases-wrapper
        div.phases(:style="{width: (nonFinalPhases.length * 320) + 'px'}")
          phase(v-for="phase in nonFinalPhases", :phase="phase", @modal="openModalByName")
      board-sidebar.sidebar(v-if="finalPhases.length", @modal="openModalByName")


  </template>

  <style scoped>

  .boards {
    display: flex;
    justify-content: flex-end;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    height: 100%;
  }

  .phases-wrapper {
    overflow-x: auto;
    overflow-y: auto;
    padding: 1em;
    height: 100%;
  }

  .phases {
    display: flex;
    flex-wrap: nowrap;
    transition: transform 1s;
    height: 100%;
    overflow-y: auto;
  }

  .phase {
    height: 95%;
  }

  .sidebar {
    width: 250px;
  }

  </style>
