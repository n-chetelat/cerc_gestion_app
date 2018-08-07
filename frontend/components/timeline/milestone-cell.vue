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
    dateIds() {
      return [this.date.id, ...this.date.months.map(m => m.id)]
    },
    dateInPersonRange() {
      const cellDate = new Date(`${this.date.id} EST`)

      // Make starting and eding month equal to cell date if the date is in months, not semesters.

      let startDateId = this.profile.starting_date
      if (this.dateIds.includes(startDateId)) { startDateId = this.dateIds[0] }
      const startDate = new Date(`${startDateId} EST`)

      let endDateId = this.profile.ending_date
      if (this.dateIds.includes(endDateId)) { endDateId = this.dateIds[0] }
      const endDate = new Date(`${endDateId} EST`)

      return (cellDate >= startDate && cellDate <= endDate)
    }
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
        if (err.response.data.error === "Invalid date for milestone") {
          this.$emit("error", {errorType: "invalid_milestone_date"})
        } else this.$emit("error")
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
    :class="{'--highlighted': beingDraggedOver, '--in-range': dateInPersonRange}")

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
  &.--in-range {
    background-color: color(yellow alpha(20%));
  }
}

</style>
