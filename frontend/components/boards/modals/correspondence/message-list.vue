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
    }
  },
  computed: {
  },
  methods: {
    toggleSelectMessage(event) {
      const messageEl = event.currentTarget.parentElement
      if (messageEl.classList.contains("--open")) {
        messageEl.classList.remove("--open")
      } else {
        messageEl.classList.add("--open")
      }
    },
  },
}
</script>

<template lang="pug">
  div.message-list
    ul
      li.message-line(v-for="message in thread.messages")
        div.heading(@click="toggleSelectMessage($event)")
          h3 {{message.from_address | truncate(25)}}
          div.snippet {{message.snippet | truncate(25)}}
          span.timestamp {{formattedDate(message.timestamp)}}
        div.content(v-html="message.content")

</template>

<style>

  :root {
    --themeColor: #00a668;
  }

  .message-list {
    & .message-line {
      padding: .5em;
      margin-bottom: 3px;
      border-bottom: 1px solid gray(190);
      & .heading {
        padding: .5em;
      }
      & h3 {
        width: 40%;
        display: inline-block;
        margin: 0;
        padding: 0;
        font-size: 1.1em;
      }
      & .timestamp {
        width: 20%;
        float: right;
      }
      & .snippet {
        width: 40%;
        padding: 0 1em;
      }
      & .timestamp, & .message-count, & .snippet {
        font-size: 1em;
        color: gray(100);
      }
      & .content {
        max-height: 0;
        padding: 0 1em;
        overflow-y: auto;
        transition: max-height 0.2s ease-in, padding 0.3s ease-in;
      }
      &.--open .content {
        max-height: 200px;
        padding: 1em;
      }
      &.--open .snippet {
        visibility: hidden;
      }
    }
  }

</style>
