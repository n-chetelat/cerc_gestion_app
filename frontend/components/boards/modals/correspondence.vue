<script>

import * as moment from "moment"

import { mapGetters, mapActions } from "vuex"

import Modal from "../../shared/modal.vue"

export default {
  name: "Correspondence",
  props: {
    person: {
      required: true
    }
  },
  data() {
    return {
      correspondence: null,
      correspondenceNotFound: false,
      openThreadId: null
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
    }
  },
  methods: {
    ...mapActions("email", ["fetchPersonEmail"]),
    closeModal() {
      this.$emit("close")
    },
    formattedDate(timestamp) {
      const date = moment(timestamp)
      return date.format("MMM Do YY")
    }
  },
  components: {
    Modal,
  }
}
</script>

<template lang="pug">
  modal(@close="closeModal")
    template(slot="header")
      h1 Correspondence with {{person.full_name}}
    template(slot="body")
      div.correspondence
        ul.thread-list(v-if="isLoaded")
          li.thread-line(v-for="thread in correspondence.threads", @click="openThreadId = thread.id")
            h2 {{thread.subject || `Thread#` + thread.id}}
            span.timestamp {{formattedDate(thread.created_at)}}
            //- div.message-list(:class="{'--open': openThreadId === thread.id}")
            //-   div.message-line(v-for="message in thread.messages")
            //-     div(v-html="message.content")


</template>

<style>
  .correspondence {
    & .thread-list {
      max-height: 400px;
      overflow: auto;
      list-style-type: none;
    }
    & .thread-line {
      & h2 {
        margin-bottom: 3px;
      }
    }
    & .message-list {
      overflow: auto;
      & .message-line {
        display: none
      }
      &.--open {
        & .message-line {
          display: block;
        }
      }
    }
    & .timestamp {
      font-size: .8em;
      color: gray(190);
      display: inline-block;
    }
  }

</style>
