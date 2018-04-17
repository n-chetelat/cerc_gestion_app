<script>

import { mapGetters, mapActions } from "vuex"

import { SlideXLeftTransition, CollapseTransition, SlideYUpTransition } from 'vue2-transitions'

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
    async showFlash(status) {
      if (status === "success") {
        await this.loadPersonCorrespondence()
      }
      this.composing = false
      this.flashMessage = status
      const wrapper = this.$el.querySelector(".wrapper")
      wrapper.scrollTo({top: -10000, behavior: "smooth"})
      setTimeout(() => {
        this.flashMessage = null
      }, 5000)
    },
  },
  components: {
    Modal,
    ComposeEmail,
    MessageList,
    SlideXLeftTransition,
    CollapseTransition,
    SlideYUpTransition
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
            slide-y-up-transition
              div.flash.success(v-if="flashMessage === 'success'", @click="flashMessage = null") The message has been sent.
            slide-y-up-transition
              div.flash.error(v-if="flashMessage === 'error'", @click="flashMessage = null") There was an error when sending the message.
            div
              button.icon.back-btn(@click="goToThreadList") Back
              h2 {{getThreadSubject(openThread)}}
              button.icon.edit-btn(type="button", @click="composing = !composing", v-tooltip="'Compose message'")
            collapse-transition
              compose-email(v-show="composing", :thread="openThread", @scrap="scrapMessage", @success="showFlash('success')", @error="showFlash('error')")
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
      padding-bottom: 2em;
    }
    & .thread-line {
      cursor: pointer;
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
      width: 70%;
      margin: auto;
      padding: 15px;
      border-radius: 5px;
      color: white;
      text-align: center;
      &.success {
        background-color: color(green alpha(50%));
      }
      &.error {
        background-color: color(red alpha(50%));
      }
    }
    & .thread {
      & h2 {
        display: inline-block;
      }
    }
  }

</style>
