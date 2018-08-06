<script>

import { mapActions } from "vuex"

export default {
  name: "Graduate",
  props: {
    profile: { required: true },
  },
  data() {
    return {
      isGraduated: false
    }
  },
  methods: {
    ...mapActions("profiles", ["markProfileAsFinished"]),
    async markAsFinished() {
      await this.markProfileAsFinished(this.profile.uuid).then(() => {
        this.isGraduated = true
      })
    }
  },
}
</script>

<template lang="pug">
  div.graduate
    button.caution.graduate-flex-item(@click="markAsFinished", :disabled="isGraduated", :class="{'--disabled': isGraduated}") Mark as finished
    p.graduate-text.graduate-flex-item(v-if="!isGraduated") Please be sure you wish to mark this individual as finished. This action cannot be undone.
    p.graduate-text.graduate-flex-item(v-else) This individual has been marked as graduated.

</template>

<style>

  @import "../../../init/variables.css";

  .graduate {
    display: flex;
    width: 100%;
    height: 200px;
    margin-top: 2em;
    flex-wrap: wrap;
    justify-content: center;

    & .graduate-flex-item {
      width: 60%;
    }

    & .graduate-text {
      margin-top: 2em;
      text-align: center;

    }
  }


</style>
