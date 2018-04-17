<script>

import { mapGetters, mapActions } from "vuex"

import { SlideXLeftTransition, CollapseTransition } from 'vue2-transitions'

import DatesMixin from "../../../mixins/dates-mixin"

import Modal from "../../shared/modal.vue"
import ComposeEmail from "./correspondence/compose-email.vue"
import MessageList from "./correspondence/message-list.vue"

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
      composing: false,
      flashMessage: null,
    }
  },
  created() {
    this.loadPersonCorrespondence()
  },
  computed: {
    ...mapGetters("email", ["emailByPerson"]),
    isLoaded() {
      return this.person && this.correspondence
    },
  },
  methods: {
    ...mapActions("email", ["fetchPersonEmail"]),
    loadPersonCorrespondence() {
      this.fetchPersonEmail(this.person.id).then(() => {
        this.correspondence = this.emailByPerson[this.person.id]
      }).catch((error) => {
        this.correspondenceNotFound = true
      })
    },
    closeModal() {
      this.$emit("close")
    },
    getThreadSubject(thread) {
      return thread.subject || "(no subject)"
    },
    getThreadSnippet(thread) {
      if (thread.messages.length) {
        return thread.messages[0].snippet
      }
      return "(no content)"
    },
    goToThreadList() {
      this.composing = false
      this.openThread = null
    },
    scrapMessage() {
      this.composing = false
    },
    async messageSuccess() {
      await this.loadPersonCorrespondence()
      this.composing = false
      this.flashMessage = "success"
    },
    messageError() {
      this.composing = false
      this.flashMessage = "error"
    }
  },
  components: {
    Modal,
    ComposeEmail,
    MessageList,
    SlideXLeftTransition,
    CollapseTransition
  }
}
</script>

<template lang="pug">
  modal(@close="closeModal")
    template(slot="header")
      h1 Correspondence with {{person.full_name}}
    template(slot="body")
      div.correspondence(v-if="isLoaded")
        slide-x-left-transition(group)
          div.wrapper.thread-list(v-if="!openThread", :key="'threadList'")
            ul
              li.thread-line(v-for="thread in correspondence.threads", @click="openThread = thread")
                h2 {{getThreadSubject(thread) | truncate(25)}}
                  span.message-count ({{thread.messages.length}})
                span.snippet {{getThreadSnippet(thread) | truncate(25)}}
                span.timestamp {{formattedDate(thread.timestamp)}}

          div.wrapper.thread(v-else, :key="'threadShow'")
            span.flash.success(v-if="flashMessage === 'success'", @click="flashMessage = null") Message sent.
            span.flash.error(v-if="flashMessage === 'error'", @click="flashMessage = null") Error when sending message.
            div
              button.icon.back-btn(@click="goToThreadList") Back
              h2 {{getThreadSubject(openThread)}}
              button.icon.edit-btn(type="button", @click="composing = !composing", v-tooltip="'Compose message'")
            collapse-transition
              compose-email(v-show="composing", :thread="openThread", @scrap="scrapMessage", @success="messageSuccess", @error="messageError")
            message-list(:thread="openThread")



</template>

<style>

  :root {
    --windowHeight: 400;
  }

  .correspondence {
    & .wrapper {
      max-height: var(--windowHeight)px;
      overflow: auto;
      position: relative;
    }
    & .thread-line {
      padding: 1em .5em;
      margin-bottom: 3px;
      border-bottom: 1px solid gray(190);
      & h2 {
        width: 40%;
        display: inline-block;
        margin: 0;
        padding: 0;
        font-size: 1.1em;
      }
      & .message-count {
        margin-left: 5px;
      }
      & .timestamp {
        width: 20%;
      }
      & .snippet {
        width: 40%;
        padding: 0 1em;
      }
      & .timestamp, & .message-count, & .snippet {
        font-size: 1em;;
      }
    }
    & .timestamp, & .message-count, & .snippet {
      font-size: .8em;
      color: gray(190);
      display: inline-block;
    }
    & .icon {
      display: inline-block;
      padding: 5px;
      margin: auto 5px;
      width: 32px;
      height: 32px;
    }
    & .back-btn {
      border: none;
      display: block;
      background: url("../../../static/icons/arrow-left-charcoal.svg") left center / 60% no-repeat;
      padding-left: 40px;
      color: black;
      &:hover {
        background: url("../../../static/icons/arrow-left.svg") left center / 70% no-repeat;
      }
    }
    & .edit-btn {
      background: url("../../../static/icons/pencil-charcoal.svg") left center / 60% no-repeat;
      &:hover {
        background: url("../../../static/icons/pencil.svg") left center / 70% no-repeat;
      }
    }
    & .flash {
      position: absolute;
      display: inline-block;
      padding: 5px;
      &.success {
        background-color: green;
      }
      &.error {
        background-color: red;
      }
    }
    & .thread {
      & h2 {
        display: inline-block;
      }
    }
  }

</style>
