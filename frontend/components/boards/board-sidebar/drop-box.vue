<script>

import { mapGetters, mapActions } from "vuex"

import { find } from "lodash-es"

export default {
  name: "DropBox",
  props: {
    phase: {
      required: true
    }
  },
  data() {
    return {
      beingDraggedOver: false
    }
  },
  computed: {
    ...mapGetters("boards", ["currentBoard"])
  },
  methods: {
    ...mapActions("boards", ["changePersonPhase"]),
    ...mapActions("application", ["markApplicationForDeletion"]),
    onDragOver(event) {
      this.beingDraggedOver = true
      event.dataTransfer.dropEffect = "move"
    },
    onDrop(event) {
      this.beingDraggedOver = false
      event.dataTransfer.dropEffect = "move"
      const [personId, oldPhaseId] = event.dataTransfer.getData("text")
        .split(",")
      if (oldPhaseId === this.phase.uuid) return false
      const payload = {phaseId: this.phase.uuid, personId, oldPhaseId}
      this.changePersonPhase(payload).then(() => {
        if (this.phase.has_callback) {
          const person = find(this.phase.persons, (p) => p.uuid === personId)
          this.$emit("modal", "person-info", { person, tab: "email"})
          return this.markApplicationForDeletion(person.application_id)
        }
      }).catch((err) => {
        this.$emit("modal", "server-error", {})
      })
    },
  },
}
</script>

<template lang="pug">
  div.drop-box(
    :style="{'border-color': phase.color, 'color': phase.color}",
    v-tooltip="`Drop person here to close application`",
    @dragover.prevent="onDragOver",
    @dragend.prevent="beingDraggedOver = false",
    @dragleave.prevent="beingDraggedOver = false",
    @drop.prevent="onDrop"
    :class="{'--expanded': beingDraggedOver}")
    p {{phase.title}}

</template>

<style scoped>

.drop-box {
  border: 3px dashed;
  display: flex;
  background-color: white;
  transition: .5s ease;
  & p {
    font-weight: bold;
    margin: auto;
    opacity: 1;
  }
  &.--expanded {
    background-color: gray(80%);
  }
}

</style>
