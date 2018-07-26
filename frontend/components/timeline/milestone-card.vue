<script>
import { mapGetters, mapActions } from "vuex"

export default {
  name: "MilestoneCard",
  props: {
    personMilestone: { required: true },
  },
  data() {
    return {
      beingDragged: false,
    }
  },
  computed: {
    ...mapGetters("milestones", ["milestonesById", "milestonesByPersonId"]),
  },
  methods: {
    onDragStart(event) {
      this.beingDragged = true
      event.dataTransfer.setData("text/plain",
        `${this.personMilestone.id},${this.personMilestone.person_id},${this.personMilestone.date}`)
      event.dataTransfer.dropEffect = "move"
    },
    onDragEnd(event) {
      this.beingDragged = false
    }
  },
  components: {

  }
}
</script>

<template lang="pug">
  div.milestone-card(
    :draggable="true", @click="$emit('modal')",
    @dragstart="onDragStart", @dragend.prevent="onDragEnd",
    :class="{'--hidden': beingDragged}") {{milestonesById[personMilestone.positions_milestone_id].title}}

</template>

<style>

@import "../../init/variables.css";

.milestone-card {
  cursor: pointer;
  padding: 3px;
  border: 2px solid var(--themeColor);
  border-radius: 3px;
  background-color: #00a66855;
  width: 100%;
  &:before {
    content: "⁞ ";
    color: gray;
  }
  &.--hidden {
    opacity: .5;
  }
}

</style>
