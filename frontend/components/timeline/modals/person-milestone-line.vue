<script>

import { mapGetters, mapActions } from "vuex"

export default {
  name: "PersonMilestoneLine",
  props: {
    personMilestone: { required: true },
    positionDates: { default: () => [] }
  },
  data() {
    return {
      commentOpen: false
    }
  },
  computed: {
    ...mapGetters("milestones", ["milestonesById"]),
  },
  methods: {
    ...mapActions("milestones", ["updatePersonMilestone", "destroyPersonMilestone"]),
    savePersonMilestone() {
      const params = {
        id: this.personMilestone.id,
        date: this.personMilestone.date,
        comment: this.personMilestone.comment
      }
      this.updatePersonMilestone(params)
        .then(() => {
          this.$emit("valid", false)
        })
        .catch((err) => {
          this.$emit("valid", true)
        })
    },
    async deletePersonMilestone() {
      await this.destroyPersonMilestone(this.personMilestone.id)
    }
  }
}
</script>

<template lang="pug">
  div.person-milestone-line
    label {{milestonesById[personMilestone.positions_milestone_id].title}}
    select(v-model="personMilestone.date", @change="savePersonMilestone")
      option(v-for="date in positionDates", :value="date.id") {{date.label}}
    button.delete(type="button", @click="deletePersonMilestone")
    button.comment(type="button", @click="commentOpen = !commentOpen") {{(commentOpen) ? 'close' : 'comment'}}
    div.comment-text(v-if="commentOpen")
      textarea(v-model="personMilestone.comment")
      button(type="button", @click="savePersonMilestone") save

</template>

<style>

  @import "../../../init/variables.css";

  .person-milestone-line {
    display: flex;
    flex-wrap: wrap;
    width: 100%;

    & .comment-text {
      width: 100%;
      display: flex;
      flex-direction: column;
      & textarea {
        width: 90%;
        margin: .7em auto;
        border: 2px solid gray;
        height: 5em;
        overflow-y: auto;
      }
      button {
        width: 50%;
        margin: auto;
        border: 1px solid transparent;
        &:hover {
          border: 1px solid;
        }
      }
    }

    & button.comment {
      width: 93px;
      text-transform: none;
      font-size: .8em;
      padding: 10px;
    }
  }


</style>
