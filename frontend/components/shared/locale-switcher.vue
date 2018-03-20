<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: "LocaleSwitcher",
  computed: {
    ...mapGetters('locales', ["currentLocale", "localesByCode"]),
    switcherLabel() {
      const opposite = this.localesByCode[this.currentLocale].opposite
      return this.localesByCode[opposite].label
    }
  },
  methods: {
    ...mapActions('locales', ["switchLocale"])
  }
}
</script>

<template lang="pug">
  span.locale-switcher
    button(type="button", @click="switchLocale") {{switcherLabel}}
</template>

<style>

  .locale-switcher {
    display: inline-block;
  }

  .locale-switcher button {
    background-color: white;
    padding: 15px;
    border: 1px solid black;
    cursor: pointer;
  }

  .locale-switcher button:hover {
    text-decoration: underline;
  }

</style>
