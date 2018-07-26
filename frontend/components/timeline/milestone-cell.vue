<script>
import { mapGetters, mapActions } from "vuex"

import MilestoneCard from "./milestone-card.vue"

export default {
  name: "MilestoneCell",
  props: {
    profile: { required: true },
    date: { required: true },
    personMilestones: { default: () => []  },
  },
  data() {
    return {
      beingDraggedOver: false,
    }
  },
  computed: {
    ...mapGetters("milestones", ["milestonesById", "milestonesByPersonId"]),
  },
  methods: {
    ...mapActions("milestones", ["updatePersonMilestone"]),
    onDragOver(event) {
      this.beingDraggedOver = true
      event.dataTransfer.dropEffect = "move"
    },
    onDrop(event) {
      this.beingDraggedOver = false
      event.dataTransfer.dropEffect = "move"
      const [personMilestoneId, personId, oldDate] = event.dataTransfer.getData("text")
        .split(",")

      if (personId !== this.profile.uuid) return false
      if (oldDate === this.date.id) return false

      const params = {
        id: personMilestoneId,
        date: this.date.id
      }
      this.updatePersonMilestone(params).then(() => {

      }).catch((err) => {
        this.$emit("error")
      })
    },
  },
  components: {
    MilestoneCard,
  }
}
</script>

<template lang="pug">
  div.milestone-cell(
    @dragover.prevent="onDragOver",
    @dragend.prevent="beingDraggedOver = false",
    @dragleave.prevent="beingDraggedOver = false",
    @drop.prevent="onDrop",
    :class="{'--highlighted': beingDraggedOver}")

    ul.milestone-list(v-if="personMilestones.length")
      li.milestone(v-for="personMilestone in personMilestones")
        milestone-card(:person-milestone="personMilestone", @modal="$emit('modal')")

</template>

<style>

@import "../../init/variables.css";

.milestone-cell {
  height: 100%;
  width: 100%;
  & .milestone-list {
    display: flex;
    flex-direction: column;
    max-height: var(--cellMinHeight)px;
    overflow-y: auto;
    height: 100%;
    justify-content: space-evenly;
  }
  & .milestone {
    width: 100%;
    margin: 2px auto;
  }
  &.--highlighted {
    background-color: color(var(--themeColor) alpha(20%));
  }
}

</style>
