<script>

import { mapGetters, mapActions } from "vuex"

import { filter, keyBy } from "lodash-es"

import PersonMilestoneLine from "./person-milestone-line"

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
      newMilestoneDates: {},
      formHasError: false
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
    createNewPersonMilestone(milestone) {
      const params = {
        person_id: this.profile.id,
        positions_milestone_id: milestone.id,
        date: this.newMilestoneDates[milestone.id]
      }
      this.createPersonMilestone(params)
        .then(() => {
          this.formHasError = false
        })
        .catch((err) => {
          this.formHasError = true
        })
    },
    setFormError(value) {
      this.formHasError = value
    }
    // savePersonMilestone(personMilestone) {
    //   const params = {
    //     id: personMilestone.id,
    //     date: personMilestone.date
    //   }
    //   this.updatePersonMilestone(params)
    //     .then(() => {
    //       this.formHasError = false
    //     })
    //     .catch((err) => {
    //       this.formHasError = true
    //     })
    // },
    // async deletePersonMilestone(personMilestone) {
    //   await this.destroyPersonMilestone(personMilestone.id)
    // }
  },
  components: {
    PersonMilestoneLine
  }
}
</script>

<template lang="pug">
  div.milestones-form

    div.error-msg(v-if="formHasError")
      p One or more of the milestone dates you have chosen is invalid.
      p Please be sure that the dates are within the range of the person's Starting and Ending dates.

    div(v-if="positionMilestones.length")
      ul
        li.field-row(v-for="personMilestone in personMilestones")
          person-milestone-line(:person-milestone="personMilestone", :position-dates="positionDates",
            @valid="setFormError")
          //- label {{milestonesById[personMilestone.positions_milestone_id].title}}
          //- select(v-model="personMilestone.date", @change="savePersonMilestone(personMilestone)")
          //-   option(v-for="date in positionDates", :value="date.id") {{date.label}}
          //- button.delete(type="button", @click="deletePersonMilestone(personMilestone)")

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

    & .error-msg {
      color: red;
      text-align: center;
      font-size: .9em;
    }

    & .field-row {
      & label {
        width: 30%;
        padding-top: 1em;
      }
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
