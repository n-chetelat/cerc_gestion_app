<script>
import { mapGetters, mapActions } from "vuex"

export default {
  name: "MilestoneCell",
  props: {
    personMilestones: { default: () => []  },
    semester: { required: true },
  },
  data() {
    return {

    }
  },
  computed: {
    ...mapGetters("milestones", ["milestonesById", "milestonesByPersonId"]),
  },
  methods: {
  },
  components: {

  }
}
</script>

<template lang="pug">
  div.milestone-cell
    ul(v-if="personMilestones.length")
      li(v-for="personMilestone in personMilestones", @click="$emit('modal')") {{milestonesById[personMilestone.positions_milestone_id].title}}

</template>

<style>

@import "../../init/variables.css";

.milestone-cell {

}

</style>
