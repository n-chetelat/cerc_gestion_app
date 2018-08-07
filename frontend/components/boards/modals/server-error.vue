<script>

import Modal from "../../shared/modal.vue"

export default {
  name: "ServerError",
  props: {
    errorType: {}
  },
  methods: {
    closeModal() {
      this.$emit("close")
    }
  },
  components: {
    Modal,
  }
}
</script>

<template lang="pug">
  modal.error-message(@close="closeModal")
    h1.error-message-header(slot="header")
      span(v-if="errorType === 'invalid_milestone_date'") Invalid milestone date
      span(v-else) Server Error
    div.error-message-body(slot="body")
      div(v-if="errorType === 'invalid_milestone_date'")
        p The date for this milestone could not be updated.
        p Please make sure the date you have chosen is within the range of this person's Starting and Ending dates.
      div(v-else)
        p There has been an error with this action.
        p Please try reloading the page or contact technical support.




</template>

<style>

  @import "../../../init/index.css";

  .error-message {
    min-height: 300px;
    max-height: 500px;
    overflow: auto;
    text-align: center;


    & .error-message-body {
    color: var(--paragraphColor);
      width: 70%;
      max-width: 600px;
      margin: auto;
      padding: 1em;
      font-size: 1.1em;
      border-radius: 5px;
    }
  }


</style>
