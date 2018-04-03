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
      ...mapGetters("boards", ["boardsById"]),
      isLoaded() {
        return !!(this.loaded && this.board)
      },
      board() {
        return this.boardsById[this.boardId]
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

      div.carrousel
        div.navigation.--left
          span.arrow-icon(@click="scrollLeft")
        div.phases-wrapper
          div.phases(:style="{width: (board.phases.length * 320) + 'px', transform: 'translate(' + phasesScrollX + 'px)'}")
            phase(v-for="phase in board.phases", :phase="phase", @modal="openModalByName")
        div.navigation.--right
          span.arrow-icon(@click="scrollRight")
  </template>

  <style scoped>

  .boards {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;

    & .carrousel {
      display: flex;
    }

    & .navigation {
      width: 7em;
      background-color: black;
      padding: 5px;
      & .arrow-icon {
        cursor: pointer;
        margin-top: 4px;
        display: inline-block;
        width: 50px;
        height: 50px;
        transition: background 1s;
      }
      &.--left {
        & .arrow-icon {
          background: url("../static/icons/circle-left-black.svg") center center / 100% no-repeat rgb(50, 50, 50);
        }
        & .arrow-icon:hover {
          background: url("../static/icons/circle-left-black.svg") center center / 100% no-repeat white;
        }
      }
      &.--right {
        & .arrow-icon {
          background: url("../static/icons/circle-right-black.svg") center center / 100% no-repeat rgb(50, 50, 50);
        }
        & .arrow-icon:hover {
          background: url("../static/icons/circle-right-black.svg") center center / 100% no-repeat white;
        }
      }
    }
  }

  .phases-wrapper {
    overflow-x: auto;
    overflow-y: hidden;
    height: 100%;
    padding: 1em;
  }

  .phases {
    display: flex;
    flex-wrap: nowrap;
    transition: transform 1s;
  }

  </style>
