  <script>
import SceneMixin from "mixins/scene-mixin.js"

import { mapGetters, mapActions } from "vuex"

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
      isLoaded() {
        return this.loaded && this.board
      },
      board() {
        return this.boardsById[this.boardId]
      }
    },
    methods: {
      ...mapActions("boards", ["fetchBoard"]),
    },
    components: {
      Phase
    }
  }
  </script>

  <template lang="pug">
    div.boards(v-if="isLoaded")
      div.phases
        phase(v-for="phase in board.phases", :phase="phase")
  </template>

  <style scoped>

    .boards {

    }

  </style>
