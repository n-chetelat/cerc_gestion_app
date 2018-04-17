<script>

import Vue from "vue"
import DatesMixin from "../../../../mixins/dates-mixin"

import { CollapseTransition } from 'vue2-transitions'

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
      openMessages: {}
    }
  },
  computed: {
  },
  methods: {
    toggleSelectMessage(message) {
      if (this.openMessages[message.id]) {
        Vue.delete(this.openMessages, message.id)
      } else {
        Vue.set(this.openMessages, message.id, true)
      }
    },
  },
  components: {
    CollapseTransition
  }
}
</script>

<template lang="pug">
  div.message-list
    ul
      li.message-line(v-for="message in thread.messages")
        div.heading(@click="toggleSelectMessage(message)")
          h3 {{message.from_address | truncate(25)}}
          div.snippet {{message.snippet | truncate(25)}}
          span.timestamp {{formattedDate(message.timestamp)}}
        collapse-transition
          div.content(v-if="openMessages[message.id]")
            div.info-row
              label From
              div.info {{message.from_address}}
            div.info-row
              label Date
              div.info {{formattedDateTime(message.timestamp)}}
            div.message(v-html="message.content")

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
        cursor: pointer;
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
        padding: 1em;
        & .info-row {
          display: flex;
          width: 50%;
          padding: 5px 0;
          font-size: .8em;
          color: gray(95);
          & label {
            width: 20%;
            padding-right: 10px;
            font-weight: bold;
          }
          & .info {
            width: 80%;
          }
        }
        & .message {
          margin-top: 1em;
        }
      }
    }
  }

</style>
