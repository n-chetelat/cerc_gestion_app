<script>

import { SlideYUpTransition } from 'vue2-transitions'

export default {
  name: "FlashMessages",
  props: {
    flashMessage: {}
  },
  data() {
    return {
    }
  },
  methods: {
    closeFlash() {
      this.$emit("close")
    }
  },
  components: {
    SlideYUpTransition
  }
}
</script>

<template lang="pug">
  div.flash-messages(@click="closeFlash")
    slide-y-up-transition
      div.flash.success(v-if="flashMessage === 'success'") The message has been sent.
    slide-y-up-transition
      div.flash.error(v-if="flashMessage === 'error'") There was an error when sending the message.



</template>

<style>

  .flash-messages {

  }

</style>
