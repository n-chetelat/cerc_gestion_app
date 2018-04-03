<script>

import { mapGetters } from "vuex"

import Modal from "../../shared/modal.vue"

export default {
  name: "RecruitmentFormError",
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
  modal.error-message(@close="closeModal")
    h1.error-message-header(slot="header")
      span(v-if="currentLocale === 'en'") Submission Error
      span(v-if="currentLocale === 'fr'") Erreur de soumission
    div.error-message-body(slot="body")
      div(v-if="currentLocale === 'en'")
        p There was an error with the submission of your application.
        p Please try again later.
        p
          a(href="http://cerc-datascience.polymtl.ca/") Back to the home page
      div(v-if="currentLocale === 'fr'")
        p Il s'est produit une erreur avec la soumission de votre application.
        p Veuillez réessayer plus tard.
        p
          a(href="http://cerc-datascience.polymtl.ca/") Retour à l'accueil




</template>

<style>

  :root {
    --errorColor: black;
  }

  .error-message {
    min-height: 300px;
    max-height: 500px;
    overflow: auto;
    text-align: center;

    & .error-message-header {
      color: var(--errorColor);
    }

    & .error-message-body {
      width: 70%;
      max-width: 600px;
      margin: auto;
      background-color: var(--errorColor);
      color: white;
      padding: 1em;
      font-size: 1.4em;
      border-radius: 5px;

      & a {
        color: white;
      }
    }
  }


</style>
