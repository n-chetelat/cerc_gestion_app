<script>
import { mapActions } from "vuex"

import { VueEditor } from 'vue2-editor'

import LoadingScreen from "../../../../shared/loading-screen.vue"

import DatesMixin from "../../../../../mixins/dates-mixin"

export default {
  name: "ComposeEmail",
  mixins: [DatesMixin],
  props: {
    thread: {
      required: true,
    },
    message: {}
  },
  created() {
    this.messageRecipients = this.thread.participants.slice(0)
  },
  data() {
    return {
      isLoading: false,
      messageRecipients: [],
      messageCc: [],
      messageBCc: [],
      composedMessage: "",
      newAddress: null,
      newCcAddress: null,
      newBCcAddress: null,
    }
  },
  computed: {

  },
  methods: {
    ...mapActions("email", ["sendEmail"]),
    addNewAddressToList(kind) {
      let list, address
      if (kind === "recipient") {
        list = this.messageRecipients
        address = this.newAddress
        this.newAddress = null
      } else if (kind === "cc") {
        list = this.messageCc
        address = this.newCcAddress
        this.newCcAddress = null
      } else if (kind === "bcc") {
        list = this.messageBCc
        address = this.newBCcAddress
        this.newBCcAddress = null
      }
      if (address && (list.indexOf(address) < 0)) {
        list.push(address)
      }
    },
    removeAddressFromList(kind, address) {
      let list
      if (kind === "recipient") {
        list = this.messageRecipients
      } else if (kind === "cc") {
        list = this.messageCc
      } else if (kind === "bcc") {
        list = this.messageBCc
      }
      const index = list.indexOf(address)
      if (index > -1) {
        list.splice(index, 1)
      }
    },
    scrapMessage() {
      this.$emit("scrap")
      this.composedMessage = ""
      this.messageRecipients = this.thread.participants.slice(0)
      this.messageCc = []
      this.messageBCc = []
    },
    async sendMessage() {
      if (this.isLoading) return
      const payload = {
        threadId: this.thread.id,
        params: {
          recipients: this.messageRecipients,
          cc: this.messageCc,
          bcc: this.messageBCc,
          body: this.composedMessage
        }
      }
      this.isLoading = true
      await this.sendEmail(payload).then(() => {
        this.$emit("success")
      }).catch((error) => {
        this.$emit("error")
      })
      this.isLoading = false
    }
  },
  components: {
    LoadingScreen,
    VueEditor
  }
}
</script>

<template lang="pug">
  div.compose-email
    div.loading(v-if="isLoading")
    div.address-list
      div.address-list-row
        label To
        div.respond-to-address-list
          span.respond-to-address(v-for="address in messageRecipients") {{address}}
            button.remove-btn(type="button", @click="removeAddressFromList('recipient', address)") x
          input.respond-to-address-input(v-model="newAddress", @blur="addNewAddressToList('recipient')", @keyup.enter="addNewAddressToList('recipient')", placeholder="Add Recipient")
      div.address-list-row
        label Cc
        div.respond-to-address-list
          span.respond-to-address(v-for="address in messageCc") {{address}}
            button.remove-btn(type="button", @click="removeAddressFromList('cc', address)") x
          input.respond-to-address-input(v-model="newCcAddress", @blur="addNewAddressToList('cc')", @keyup.enter="addNewAddressToList('cc')", placeholder="Add Cc")
      div.address-list-row
        label Bcc
        div.respond-to-address-list
          span.respond-to-address(v-for="address in messageBCc") {{address}}
            button.remove-btn(type="button", @click="removeAddressFromList('bcc', address)") x
          input.respond-to-address-input(v-model="newBCcAddress", @blur="addNewAddressToList('bcc')", @keyup.enter="addNewAddressToList('bcc')", placeholder="Add Bcc")
    div.composing-window
      div.action-menu
        button.icon.scrap-btn(type="button", @click="scrapMessage", v-tooltip="'Scrap'")
        button.icon.send-btn(type="button", @click="sendMessage", v-tooltip="'Send'")
      vue-editor(v-model="composedMessage")




</template>

<style>
  :root {
    --windowHeight: 400;
    --fieldsBoxShadow: -1px 1px 2px;
  }

  .compose-email {
    position: relative;

    & .loading {
      position: absolute;
      box-shadow: inset 1px 1px 50px rgba(0, 0, 0, .2);
      background: url("../../../../../static/images/spinner-solid.gif") center center / 10% no-repeat rgba(0,0,0,.3);
    }

    & .address-list-row {
      display: flex;
      padding: .5em;
      & label {
        width: 10%;
      }
      & .respond-to-address-list {
        width: 90%;
        max-width: 90%;
      }
    }
    & .respond-to-address {
      display: inline-block;
      padding: 3px 10px;
      margin: 0 5px 5px 0;
      border-radius: 5px;
      background-color: gray(200);
    }
    & .respond-to-address-input {
      border: none;
      box-shadow: var(--fieldsBoxShadow);
      display: block;
    }
    & .remove-btn {
      padding: 0;
      padding-left: 3px;
      background-color: transparent;
      &:hover {
        color: black;
      }
    }
    & .action-menu {
      height: 32px;
      & .icon {
        float: right;
      }
    }
    & .scrap-btn {
      background: url("../../../../../static/icons/bin-charcoal.svg") left center / 60% no-repeat;
      &:hover {
        background: url("../../../../../static/icons/bin.svg") left center / 70% no-repeat;
      }
    }
    & .send-btn {
      background: url("../../../../../static/icons/paper-plane-charcoal.svg") left center / 60% no-repeat;
      &:hover {
        background: url("../../../../../static/icons/paper-plane.svg") left center / 70% no-repeat;
      }
    }

    & .composing-window {
      display: block;
      width: 90%;
      margin: 1em auto;
      min-width: 25em;
      textarea {
        min-height: calc(var(--windowHeight) * .3)px;
        max-height: calc(var(--windowHeight) * .5)px;
        width: 100%;
        max-width: 100%;
        min-width: 100%;
        box-shadow: var(--fieldsBoxShadow);
        border: none;
        padding: 1em;
        font-family: 'Open Sans', Arial, sans-serif;
      }
    }
  }

</style>
