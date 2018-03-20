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

</style>
