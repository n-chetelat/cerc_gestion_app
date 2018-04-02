<script>

import { mapGetters } from "vuex"

import Modal from "../../shared/modal.vue"

export default {
  name: "RecruitmentFormSuccess",
  computed: {
    ...mapGetters("locales", ["currentLocale"]),
  },
  methods: {
    closeModal() {
      this.$emit("close")
    }
  },
  components: {
    Modal,
  }
}
</script>

<template lang="pug">
  modal.success-message(@close="closeModal")
    h1.success-message-header(slot="header")
      span(v-if="currentLocale === 'en'") Thank you!
      span(v-if="currentLocale === 'fr'") Merci !
    div.success-message-body(slot="body")
      div(v-if="currentLocale === 'en'")
        p Your application has been successfully submitted.
        p You will be hearing from us soon.
      div(v-if="currentLocale === 'fr'")
        p Votre application a été envoyée avec succès.
        p Nous serons bientôt en contact.




</template>

<style>

  :root {
    --successColor: black;
  }

  .success-message {
    min-height: 300px;
    max-height: 500px;
    overflow: auto;
    text-align: center;

    & .success-message-header {
      color: var(--successColor);
    }

    & .success-message-body {
      width: 70%;
      max-width: 600px;
      margin: auto;
      background-color: var(--successColor);
      color: white;
      padding: 1em;
      font-size: 1.4em;
      border-radius: 5px;
    }
  }


</style>
