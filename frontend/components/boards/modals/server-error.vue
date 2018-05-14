<script>

import Modal from "../../shared/modal.vue"

export default {
  name: "ServerError",
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
      span Server Error
    div.error-message-body(slot="body")
      div
        p There has been an error with this action.
        p Please try reloading the page or contact technical support.




</template>

<style>

  :root {
    --paragraphColor: #767676;
  }

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
