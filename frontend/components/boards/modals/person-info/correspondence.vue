<script>
import { setEmailsCallback } from "cable/board"

import { mapGetters, mapActions } from "vuex"

import { SlideXLeftTransition, CollapseTransition } from 'vue2-transitions'

import DatesMixin from "../../../../mixins/dates-mixin"

import Modal from "../../../shared/modal.vue"
import ComposeEmail from "./correspondence/compose-email.vue"
import MessageList from "./correspondence/message-list.vue"
import FlashMessages from "./correspondence/flash-messages.vue"

export default {
  name: "Correspondence",
  mixins: [DatesMixin],
  props: {
    person: {
      required: true
    },
    section: {},
  },
  data() {
    return {
      correspondence: null,
      showError: false,
      openThread: null,
      composing: false,
      flashMessage: null,
      newThread: this.section === "new",
      newMessageThread: {
        id: null,
        participants: [this.person.email],
        subject: ""
      },
      newMessageTemplate: null,
    }
  },
  beforeCreate() {
    setEmailsCallback((data) => {
      this.fetchPersonEmail(data.refresh_emails.person_id).then(() => {
        this.correspondence = this.emailByPerson[this.person.uuid]
      })
    })
  },
  async created() {
    try {
      await this.loadPersonCorrespondence()
      if (this.section === "new") {
        const payload = {phaseId: this.person.phase_id, personId: this.person.uuid}
        await this.fetchPhaseEmailTemplate(payload).then(() => {
          this.newMessageTemplate = this.emailTemplatesByPhase[this.person.phase_id]
        })
      }
    } catch(err) {
      this.showError = true
    }
  },
  computed: {
    ...mapGetters("email", ["emailByPerson"]),
    ...mapGetters("boards", ["emailTemplatesByPhase"]),
    isLoaded() {
      return this.person && this.correspondence
    },
    newMessageIsLoaded() {
      if (this.section === "new") {
        return !!this.newMessageTemplate
      }
      return true
    }
  },
  methods: {
    ...mapActions("email", ["fetchPersonEmail"]),
    ...mapActions("boards", ["fetchPhaseEmailTemplate"]),
    loadPersonCorrespondence() {
      this.fetchPersonEmail(this.person.uuid).then(() => {
        this.correspondence = this.emailByPerson[this.person.uuid]
      }).catch((error) => {
        this.showError = true
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
      this.newThread = false
      this.composing = false
      this.openThread = null
    },
    scrapMessage() {
      this.composing = false
    },
    onSuccess() {
      this.$emit("email")
      this.showFlash("success")
    },
    async showFlash(status) {
      this.composing = false
      this.flashMessage = status
      const wrapper = this.$el.querySelector(".correspondence-wrapper")
      wrapper.scrollBy({top: -10000, behavior: "smooth"})
      setTimeout(() => {
        this.flashMessage = null
      }, 5000)
    },
    onComposing() {
      this.$emit("composing")
    }
  },
  components: {
    Modal,
    ComposeEmail,
    MessageList,
    SlideXLeftTransition,
    CollapseTransition,
    FlashMessages
  }
}
</script>

<template lang="pug">

  div
    div(v-if="showError", style="text-align: center;")
      p There was an error when fetching this applicant's correspondence.
      p Make sure that this application has permission to access the associated Gmail account by navigating
        span
          a(href="/admin/google/authorize", target="_blank") &nbsp; here.
      p Otherwise, please try reloading the page or contact technical support.

    div.correspondence(v-if="isLoaded")

      slide-x-left-transition(group)
        div.correspondence-wrapper.thread-list(v-if="!openThread && !newThread", :key="'threadList'")
          button.submit.new-thread-btn(type="button", @click="newThread = true") New Thread
          div(v-if="!correspondence.threads.length")
            p You have no correspondence with this applicant so far.
          div(v-else)
            h2 All Threads
            ul
              li.thread-line(v-for="thread in correspondence.threads", @click="openThread = thread")
                h3 {{getThreadSubject(thread) | truncate(25)}}
                  span.message-count ({{thread.messages.length}})
                span.snippet {{getThreadSnippet(thread) | truncate(25)}}
                span.timestamp {{formattedDate(thread.timestamp)}}

        div.correspondence-wrapper.thread(v-if="openThread", :key="'threadShow'")
          flash-messages(:flash-message="flashMessage", @close="flashMessage = null")
          div
            button.icon.back-btn(@click="goToThreadList") Back
            h2 Messages from thread "{{getThreadSubject(openThread)}}"
            button.icon.edit-btn(type="button", @click="composing = !composing", v-tooltip="'Compose message'")
            div.attachment-msg
              p The messages below may contain attachments not shown here.
              p Please visit the associated Gmail account to view or send attachments.
          collapse-transition
            compose-email(v-show="composing", :thread="openThread", @scrap="scrapMessage", @success="onSuccess", @error="showFlash('error')", @composing="onComposing")
          message-list(:thread="openThread")

        div.correspondence-wrapper.new-thread(v-if="newThread && newMessageIsLoaded", :key="'threadNew'")
          flash-messages(:flash-message="flashMessage", @close="flashMessage = null")
          button.icon.back-btn(@click="goToThreadList") Back
          compose-email(:thread="newMessageThread", :message="newMessageTemplate", @scrap="scrapMessage", @success="onSuccess", @error="showFlash('error')", @composing="onComposing")



</template>

<style>

  :root {
    --windowHeight: 400;
  }

  .correspondence {
    & .correspondence-wrapper {
      max-height: var(--windowHeight)px;
      padding: 2em 2em;
    }
    & .attachment-msg {
      font-size: .8em;
      border: 1px solid;
      padding: 5px;
      text-align: center;
      & p {
        margin: 0;
      }
    }
    & .thread-line {
      cursor: pointer;
      padding: 1em .5em;
      margin-bottom: 3px;
      border-bottom: 1px solid gray(190);
      & h3 {
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
      background: url("../../../../static/icons/arrow-left-charcoal.svg") left center / 60% no-repeat;
      padding-left: 40px;
      color: black;
      &:hover {
        background: url("../../../../static/icons/arrow-left.svg") left center / 70% no-repeat;
      }
    }
    & .edit-btn {
      background: url("../../../../static/icons/pencil-charcoal.svg") left center / 60% no-repeat;
      &:hover {
        background: url("../../../../static/icons/pencil.svg") left center / 70% no-repeat;
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

    & .new-thread-btn {
      padding: 5px;
      width: auto;
      margin: unset;
    }
  }

</style>
