<script>

import DatesMixin from "../../../../mixins/dates-mixin"

export default {
  name: "MessageList",
  mixins: [DatesMixin],
  props: {
    thread: {
      required: true
    }
  },
  data() {
    return {
      openMessage: null,
    }
  },
  computed: {
  },
  methods: {
    selectMessage(message) {
      if (this.openMessage && this.openMessage.id === message.id) {
        this.openMessage = null
      } else {
        this.openMessage = message
      }
    },
    messageOpen(message) {
      return this.openMessage && this.openMessage.id === message.id
    }
  },
}
</script>

<template lang="pug">
  div.message-list
    ul
      li(v-for="message in thread.messages", @click="selectMessage(message)")
        h3 From {{message.from_address}}
        span.timestamp Sent on {{formattedDateTime(message.timestamp)}}
        div.snippet(v-if="!messageOpen(message)") {{message.snippet}}
        div.content(v-if="messageOpen(message)", v-html="message.content")

</template>

<style>


  .message-list {

  }

</style>
