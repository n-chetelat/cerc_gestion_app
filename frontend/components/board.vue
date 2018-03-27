  <script>
import SceneMixin from "mixins/scene-mixin.js"

import { mapGetters, mapActions } from "vuex"

import PersonInfoModal from "./shared/modals/person-info.vue"
import Phase from "./boards/phase.vue"

  export default {
    name: "Board",
    mixins: [SceneMixin],
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
      }
    },
    computed: {
      ...mapGetters("boards", ["boardsById"]),
      ...mapGetters("persons", ["currentPerson"]),
      ...mapGetters("modals", ["modalName", "modalVisible"]),
      isLoaded() {
        return this.loaded && this.board
      },
      board() {
        return this.boardsById[this.boardId]
      }
    },
    methods: {
      ...mapActions("boards", ["fetchBoard"]),
      ...mapActions("persons", ["setPerson"]),
      ...mapActions("modals", ["closeModal"]),
      hidePersonInfo() {
        this.closeModal()
        this.setPerson(null)
      }
    },
    components: {
      PersonInfoModal,
      Phase
    }
  }
  </script>

  <template lang="pug">
    div.boards(v-if="isLoaded")
      person-info-modal(@close="hidePersonInfo", v-if="modalVisible && modalName === 'person-info'", :person-id="currentPerson.id")

      div.phases
        phase(v-for="phase in board.phases", :phase="phase")
  </template>

  <style scoped>

    .boards {

    }

  </style>
