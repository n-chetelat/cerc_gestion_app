<script>

import { mapActions } from "vuex"

export default {
  name: "Advanced",
  props: {
    profile: { required: true },
  },
  data() {
    return {
      isGraduated: false,
      isCanceled: false
    }
  },
  methods: {
    ...mapActions("profiles", ["markProfileAsFinished", "markProfileAsCanceled"]),
    async markAsFinished() {
      await this.markProfileAsFinished(this.profile.uuid).then(() => {
        this.isGraduated = true
      })
    },
    async markAsCanceled() {
      await this.markProfileAsCanceled(this.profile.uuid).then(() => {
        this.isCanceled = true
      })
    }
  }
}
</script>

<template lang="pug">
  div.graduate
    div.graduate-flex-item
      h2.attention Mark person as finished
      div.graduate-text(v-if="!isGraduated")
        p Please be sure you wish to mark this individual's program as finished. This action cannot be undone.
        p Make sure this person's pending milestones are completed or deleted.
      p.graduate-text(v-else) This individual has been marked as graduated.
      button.caution.graduate-btn(@click="markAsFinished", :disabled="isGraduated", :class="{'--disabled': isGraduated}") Finish / Graduate
    div.graduate-flex-item
      h2.attention Mark program as canceled
      div.graduate-text(v-if="!isCanceled")
        p Please be sure you wish to mark this individual's program as canceled.
        p This action cannot be undone.
        p This person will have to re-apply in order to enter the program again.
      p.graduate-text(v-else) This individual's program has been marked as canceled.
      button.danger(@click="markAsCanceled", :disabled="isCanceled", :class="{'--disabled': isCanceled}") Cancel program

</template>

<style>

  @import "../../../init/variables.css";

  .graduate {
    display: flex;
    width: 100%;
    height: 200px;
    margin-top: 2em;
    flex-wrap: wrap;
    flex-flow: column;

    & .graduate-flex-item {
      width: 80%;
      margin: .5em auto;
      border-bottom: solid 1px gray;
      padding-bottom: 1em;
      &:last-of-type {
        border: none;
      }
      & button {
        width: 60%;
        height: 6em;
        display: block;
        margin: auto;
      }
    }

    & .graduate-text {
      margin-top: 1.5em;
      text-align: center;
      font-size: .9em;
      & h1 {
        font-size: 1.7em;
      }
    }

    & .graduate-btn {
      background-color: gold;
    }

    & .attention {
      text-align: center;
    }

  }


</style>
