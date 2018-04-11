  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { mapGetters, mapActions } from "vuex"

import Phase from "./boards/phase.vue"
import PersonInfoModal from "./boards/modals/person-info.vue"

  export default {
    name: "Board",
    mixins: [SceneMixin, ModalMixin],
    props: {
      boardId: {
        required: true
      }
    },
    async created() {
      await this.fetchBoard(this.boardId)
    },
    data() {
      return {
        phasesScrollX: 0,
        scrollInterval: 300,
        maxScrollX: 0,
        person: null,
      }
    },
    computed: {
      ...mapGetters("boards", ["currentBoard"]),
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
      scrollRight() {
        if (this.phasesScrollX - this.scrollInterval >= this.minScrollX) {
          this.phasesScrollX -= this.scrollInterval
        }
      },
      scrollLeft() {
        if (this.phasesScrollX + this.scrollInterval <= this.maxScrollX) {
          this.phasesScrollX += this.scrollInterval
        }
      },
      openModalByName(modalName, data) {
        if (modalName === "person-info") {
          this.person = data.person
          this.openModal(modalName)
        }
      }
    },
    components: {
      Phase,
      PersonInfoModal
    }
  }
  </script>

  <template lang="pug">
    div.boards(v-if="isLoaded")
      person-info-modal(@close="closeModal", v-if="modalVisible && modalName === 'person-info'", :person="person")

      div.phases-wrapper
        div.phases(:style="{width: (currentBoard.phases.length * 320) + 'px', transform: 'translate(' + phasesScrollX + 'px)'}")
          phase(v-for="phase in currentBoard.phases", :phase="phase", @modal="openModalByName")

  </template>

  <style scoped>

  .boards {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
  }

  .phases-wrapper {
    overflow-x: auto;
    overflow-y: auto;
    /* height: 100%; */
    padding: 1em;
  }

  .phases {
    display: flex;
    flex-wrap: nowrap;
    transition: transform 1s;
  }

  </style>
