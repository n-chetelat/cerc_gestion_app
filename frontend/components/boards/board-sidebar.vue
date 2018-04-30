<script>

import { mapGetters } from "vuex"

import DropBox from "./board-sidebar/drop-box.vue"

export default {
  name: "BoardSidebar",
  props: {
  },
  data() {
    return {
    }
  },
  computed: {
    ...mapGetters("boards", ["finalPhases"]),
  },
  methods: {
    openModal(modalName, data) {
      this.$emit('modal', modalName, data)
    },
  },
  components: {
    DropBox
  }
}
</script>

<template lang="pug">
  div.board-sidebar
    drop-box.box(v-for="phase in finalPhases", :phase="phase", @modal="openModal")

</template>

<style scoped>

:root {
  --themeColor: #00a668;
}

.board-sidebar {
  background-color: var(--themeColor);
  display: flex;
  justify-content: space-evenly;
  overflow-y: auto;
  flex-direction: column;
  box-shadow: -2px 0px 6px;
  z-index: 4;
  & .box {
    width: 90%;
    margin: auto;
    height: 20%;
    max-height: 100px;
  }
}

</style>
