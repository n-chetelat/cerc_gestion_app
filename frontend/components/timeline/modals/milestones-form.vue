<script>

import { mapGetters, mapActions } from "vuex"

import { filter, keyBy } from "lodash-es"

export default {
  name: "MilestonesForm",
  props: {
    profile: { required: true },
    personMilestones: { default: () => [] },
    positionMilestones: { default: () => [] },
    positionDates: { default: () => [] }
  },
  data() {
    return {
      newMilestoneDates: {}
    }
  },
  computed: {
    ...mapGetters("milestones", ["milestonesById"]),
    personMilestonesByMilestoneId() {
      return keyBy(this.personMilestones, "positions_milestone_id")
    },
    positionMilestonesLeftToAdd() {
      return filter(this.positionMilestones, (pm) => {
        return !this.personMilestonesByMilestoneId[pm.id]
      })
    }
  },
  methods: {
    ...mapActions("milestones", ["createPersonMilestone", "updatePersonMilestone", "destroyPersonMilestone"]),
    async createNewPersonMilestone(milestone) {
      const params = {
        person_id: this.profile.id,
        positions_milestone_id: milestone.id,
        date: this.newMilestoneDates[milestone.id]
      }
      await this.createPersonMilestone(params)
    },
    async savePersonMilestone(personMilestone) {
      const params = {
        id: personMilestone.id,
        person_id: this.profile.id,
        positions_milestone_id: personMilestone.positions_milestone_id,
        date: personMilestone.date
      }
      await this.updatePersonMilestone(params)
    },
    async deletePersonMilestone(personMilestone) {
      await this.destroyPersonMilestone(personMilestone.id)
    }
  },
  components: {
  }
}
</script>

<template lang="pug">
  div.milestones-form

    div(v-if="positionMilestones.length")
      ul
        li.field-row(v-for="personMilestone in personMilestones")
          label {{milestonesById[personMilestone.positions_milestone_id].title}}
          select(v-model="personMilestone.date", @change="savePersonMilestone(personMilestone)")
            option(v-for="date in positionDates", :value="date.id") {{date.label}}
          button.delete(type="button", @click="deletePersonMilestone(personMilestone)")

      div(v-if="positionMilestonesLeftToAdd.length")
        h2 Milestones to add
        ul
          li.field-row(v-for="milestone in positionMilestonesLeftToAdd")
            label {{milestonesById[milestone.id].title}}
            select(v-model="newMilestoneDates[milestone.id]")
              option(:value="null") Assign automatically
              hr
              option(v-for="date in positionDates", :value="date.id") {{date.label}}
            button.save(type="button", @click="createNewPersonMilestone(milestone)")

    div(v-else)
      p There are no milestones for this person's position

</template>

<style>

  @import "../../../init/variables.css";

  .milestones-form {
    display: flex;
    flex-direction: column;

    & .field-row {
      & label { width: 30%; }
      & select { width: 50%; }
      & button {
        width: 5%;
      }
      & button.save {
        &:after {
          content: "✓";
          font-size: .9em;
        }
      }
      & button.delete {
        background-color: red;
        border: 2px solid red;
        &:after {
          content: "x";
          font-size: .9em;
        }
        &:hover {
          background-color: white;
          color: red;
        }
      }
    }
  }


</style>
