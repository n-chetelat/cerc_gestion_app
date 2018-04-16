<script>

import { mapGetters, mapActions } from "vuex"

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
  },
  methods: {
    ...mapActions("email", ["fetchPersonEmail"]),
    closeModal() {
      this.$emit("close")
    },
    goToThreadList() {
      this.composing = false
      this.openThread = null
    },
    scrapMessage() {
      this.composing = false
    }
  },
  components: {
    Modal,
    ComposeEmail,
    MessageList
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
        div.wrapper.message-list(v-if="openThread")
          h2 {{openThread.subject || `Thread#` + openThread.id}}
          a.back-btn(@click="goToThreadList") Back
          button.edit-btn(type="button", @click="composing = true") Compose
          message-list(:thread="openThread")
          div(v-if="composing")
            compose-email(:thread="openThread", @scrap="scrapMessage")



</template>

<style>

  :root {
    --windowHeight: 400;
  }

  .correspondence {
    & .wrapper {
      height: var(--windowHeight)px;
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
    & .back-btn {
      display: inline-block;
      padding: 2px;
      color: gray(100);
      font-size: .9em;
    }
  }

</style>
