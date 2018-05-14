<script>

import { mapGetters, mapActions } from "vuex"
import Vue from "vue"

import Autocomplete from 'vuejs-auto-complete'

export default {
  name: "KeywordsComponent",
  props: {
    application: {
      required: true
    },
  },
  async created() {
    try {
      if (!this.keywordsByApplication[this.application.id]) {
        await this.fetchApplicationKeywords(this.application.id)
      }
      this.keywords = this.keywordsByApplication[this.application.id]
    } catch(err) {
      this.showError = true
    }
  },
  data() {
    return {
      keywords: [],
      autocompleteList: [],
      showError: false,
    }
  },
  computed: {
    ...mapGetters("keywords", ["keywordsByApplication", "autocompleteEndpoint"]),
  },
  methods: {
    ...mapActions("keywords", ["fetchApplicationKeywords", "updateKeywords",
      "removeKeywords"]),
    addNewKeyword(keyword) {
      if (keyword.constructor === Object) {
        keyword = keyword.value
      }
      const payload = { applicationId: this.application.id,
        params: { keywords: [keyword] } }
      this.updateKeywords(payload).then(() => {
        this.$refs.autocomplete.clearValues()
        this.keywords = this.keywordsByApplication[this.application.id]
      }).catch((err) => {
        this.showError = true
      })
    },
    removeKeyword(keyword) {
      const payload = { applicationId: this.application.id,
        params: { keywords: [keyword] } }
      this.removeKeywords(payload).then(() => {
        this.keywords = this.keywordsByApplication[this.application.id]
      }).catch((err) => {
        this.showError = true
      })
    },
  },
  components: {
    Autocomplete
  }
}
</script>

<template lang="pug">
  div.keywords-component
    h2 Keywords
    div.keyword-placeholder(v-if="showError")
      p There has been an error when loading the applicant's keywords.
    div(v-else)
      div.keyword-list(v-if="keywords.length")
        span.keyword-line(v-for="keyword in keywords") {{keyword}}
          button.remove-btn(@click="removeKeyword(keyword)") x
      div.keyword-placeholder(v-else)
        p There are no keywords added to this application so far.
      div.keyword-form
        autocomplete(ref="autocomplete", :source="autocompleteEndpoint", @enter="addNewKeyword"
          results-property="data",
          @selected="addNewKeyword",
          placeholder="Add a keyword...")


</template>

<style>

  :root {
    --textFamily: 'Open Sans', Arial, sans-serif;
    --textColor: gray(20);
  }

  .keywords-component {

    & .keyword-list {
      padding: .5em;
      box-shadow: -1px 1px 6px rgba(0, 0, 0, .5);
      margin-bottom: 1em;
    }

    & .keyword-line {
      background-color: beige;
      font-size: .8em;
      font-weight: bold;
      display: inline-block;
      padding: 5px;
      border-radius: 2px;
      color: gray(60%);
      border: 1px solid gray(80%);
      margin: 2px;
      & .remove-btn {
        background-color: transparent;
        padding: 0;
        margin: 0;
        margin-left: 10px;
        color: inherit;
      }
    }

    & .keyword-placeholder {
      font-size: .8em;
      color: var(--textColor);
    }

    & .keyword-form {
      font-family: var(--textFamily);
      & button.submit {
        width: 10em;
        display: inline-block;
        margin-left: 10px;
        padding: 6px;
        vertical-align: middle;
      }
    }
  }

</style>
