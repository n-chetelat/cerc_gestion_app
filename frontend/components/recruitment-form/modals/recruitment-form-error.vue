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
      span(v-if="currentLocale === 'en'") We are sorry!
      span(v-if="currentLocale === 'fr'") Nous sommes désolés !
    div.error-message-body(slot="body")
      div(v-if="currentLocale === 'en'")
        p There was an error when processing this action.
        p Please try again later.
        p
          a(href="http://cerc-datascience.polymtl.ca/") Back to the home page
      div(v-if="currentLocale === 'fr'")
        p Il s'est produit une erreur avec l'execution de cette action.
        p Veuillez réessayer plus tard.
        p
          a(href="http://cerc-datascience.polymtl.ca/") Retour à l'accueil




</template>

<style>

  @import "../../../init/variables.css";

  .error-message {
    min-height: 300px;
    max-height: 500px;
    overflow: auto;
    text-align: center;


    & .error-message-body {
    color: var(--paragraphColor);
      width: 70%;
      max-width: 600px;
      margin: auto;
      padding: 1em;
      font-size: 1.1em;
      border-radius: 5px;
    }
  }


</style>
