<script>

import DatesMixin from "../../../../mixins/dates-mixin"

export default {
  name: "ComposeEmail",
  mixins: [DatesMixin],
  props: {
    thread: {
      required: true
    }
  },
  created() {
    this.messageRecipients = this.thread.participants
  },
  data() {
    return {
      messageRecipients: [],
      messageCc: [],
      messageBCc: [],
      composedMessage: "",
      newAddress: null,
      newCcAddress: null,
      newBCcAddress: null
    }
  },
  computed: {

  },
  methods: {
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
      this.messageRecipients = []
      this.messageCc = []
      this.messageBCc = []
    },
    sendMessage() {

    }
  },
}
</script>

<template lang="pug">
  div.compose-email
    button(type="button", @click="scrapMessage") Scrap Message
    button(type="button", @click="sendMessage") Send
    div.address-list
      div.address-list-row
        label To
        div.respond-to-address-list
          span.respond-to-address(v-for="address in messageRecipients") {{address}}
            button.remove-btn(type="button", @click="removeAddressFromList('recipient', address)") x
          input.respond-to-address(v-model="newAddress", @blur="addNewAddressToList('recipient')", @keyup.enter="addNewAddressToList('recipient')", placeholder="Add Recipient")
      div.address-list-row
        label Cc
        div.respond-to-address-list
          span.respond-to-address(v-for="address in messageCc") {{address}}
            button.remove-btn(type="button", @click="removeAddressFromList('cc', address)") x
          input.respond-to-address(v-model="newCcAddress", @blur="addNewAddressToList('cc')", @keyup.enter="addNewAddressToList('cc')", placeholder="Add Cc")
      div.address-list-row
        label BCc
        div.respond-to-address-list
          span.respond-to-address(v-for="address in messageBCc") {{address}}
            button.remove-btn(type="button", @click="removeAddressFromList('bcc', address)") x
          input.respond-to-address(v-model="newBCcAddress", @blur="addNewAddressToList('bcc')", @keyup.enter="addNewAddressToList('bcc')", placeholder="Add Bcc")
    textarea.composing-window(v-model="composedMessage")




</template>

<style>
  :root {
    --windowHeight: 400;
    --fieldsBoxShadow: -1px 1px 2px;
  }

  .compose-email {
    & .address-list-row {
      display: flex;
      padding: .5em;
      & label {
        width: 10%;
      }
    }
    & span.respond-to-address {
      display: inline-block;
      padding: 3px;
      margin: 0 5px 5px 0;
      border-radius: 5px;
      background-color: gray(200);
    }
    & input.respond-to-address {
      border: none;
      box-shadow: var(--fieldsBoxShadow);
      display: block;
    }
    & .remove-btn {
      background-color: transparent;
    }

    & .composing-window {
      min-width: 25em;
      min-height: calc(var(--windowHeight) * .3)px;
      max-height: calc(var(--windowHeight) * .5)px;
      display: block;
      width: 90%;
      margin: 1em auto;
      border: none;
      box-shadow: var(--fieldsBoxShadow);
    }
  }

</style>
