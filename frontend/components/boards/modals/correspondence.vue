<script>

import { mapGetters, mapActions } from "vuex"

import DatesMixin from "../../../mixins/dates-mixin"

import Modal from "../../shared/modal.vue"
import ComposeEmail from "./correspondence/compose-email.vue"

export default {
  name: "Correspondence",
  mixins: [DatesMixin],
  props: {
    person: {
      required: true
    }
  },
  data() {
    return {
      correspondence: null,
      correspondenceNotFound: false,
      openThread: null,
      openMessage: null,
      composing: false,
      composedMessage: "",
      newAddress: null
    }
  },
  async created() {
    await this.fetchPersonEmail(this.person.id).then(() => {
      this.correspondence = this.emailByPerson[this.person.id]
    }).catch((error) => {
      this.correspondenceNotFound = true
    })
  },
  computed: {
    ...mapGetters("email", ["emailByPerson"]),
    isLoaded() {
      return this.person && this.correspondence
    },
    viewingMessage() {
      return this.openThread && this.openMessage && !this.composing
    },
    composingMessage() {
      return this.openThread && this.openMessage && this.composing
    }
  },
  methods: {
    ...mapActions("email", ["fetchPersonEmail"]),
    closeModal() {
      this.$emit("close")
    },
    goToThreadList() {
      this.openMessage = null
      this.openThread = null
    },
    goToMessageList() {
      this.openMessage = null
    },
  },
  components: {
    Modal,
    ComposeEmail
  }
}
</script>

<template lang="pug">
  modal(@close="closeModal")
    template(slot="header")
      h1 Correspondence with {{person.full_name}}
    template(slot="body")
      div.correspondence(v-if="isLoaded")
        div.wrapper.thread-list(v-if="!openThread")
          ul
            li.thread-line(v-for="thread in correspondence.threads", @click="openThread = thread")
              h2 {{thread.subject || `Thread#` + thread.id}}
              span.timestamp {{formattedDate(thread.timestamp)}}
        div.wrapper.message-list(v-if="openThread && !openMessage")
          h2 {{openThread.subject || `Thread#` + openThread.id}}
          a.back-btn(@click="goToThreadList") Back
          ul
            li.message-line(v-for="message in openThread.messages", @click="openMessage = message")
              h3 From {{message.from_address}}
              span.timestamp Sent on {{formattedDateTime(message.timestamp)}}
        div.wrapper(v-if="viewingMessage")
          h2 {{openThread.subject || `Thread#` + openThread.id}}
          a.back-btn(@click="goToMessageList") Back
          h3 From {{openMessage.from_address}}
          span.timestamp Sent on {{formattedDateTime(openMessage.timestamp)}}
          button.edit-btn(type="button", @click="composing = true") Compose
          div(v-html="openMessage.content")
        div.wrapper(v-if="composingMessage")
          a.back-btn(@click="goToMessageList") Back
          button.cancel-btn(type="button", @click="composing = false") Scrap Message
          compose-email(:thread="openThread")



</template>

<style>

  :root {
    --windowHeight: 400;
  }

  .correspondence {
    & .wrapper {
      max-height: var(--windowHeight)px;
      overflow: auto;
    }
    & .thread-line {
      & h2 {
        margin-bottom: 3px;
      }
    }
    & .timestamp {
      font-size: .8em;
      color: gray(190);
      display: inline-block;
    }
    & .back-btn, & .edit-btn, & .cancel-btn, .remove-btn {
      display: inline-block;
      padding: 2px;
      color: gray(100);
      font-size: .9em;
    }
  }

</style>
