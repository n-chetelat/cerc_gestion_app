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
    ul.milestone-list(v-if="personMilestones.length")
      li.milestone(v-for="personMilestone in personMilestones", @click="$emit('modal')") {{milestonesById[personMilestone.positions_milestone_id].title}}

</template>

<style>

@import "../../init/variables.css";

.milestone-cell {
  & .milestone-list {
    display: flex;
    flex-direction: column;
    max-height: var(--cellMinHeight)px;
    overflow-y: auto;
  }
  & .milestone {
    width: 100%;
    margin: 2px auto;
    padding: 3px;
    border: 2px solid var(--themeColor);
    border-radius: 3px;
    background-color: #00a66855;
    &:before {
      content: "⁞ ";
      color: gray;
    }
  }
}

</style>
