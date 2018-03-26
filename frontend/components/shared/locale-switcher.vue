<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: "LocaleSwitcher",
  data() {
    return {
      localesByCode: {
        en: {label: "English", opposite: "fr"},
        fr: {label: "Français",  opposite: "en"}
      }
    }
  },
  computed: {
    ...mapGetters('locales', ["currentLocale"]),
    switcherLabel() {
      const opposite = this.localesByCode[this.currentLocale].opposite
      return this.localesByCode[opposite].label
    }
  },
  methods: {
    ...mapActions('locales', ["switchLocale"]),
    async handleSwitchLocale() {
      await this.switchLocale()
      this.$emit("switch")
    }
  }
}
</script>

<template lang="pug">
  span.locale-switcher
    button(type="button", @click="handleSwitchLocale") {{switcherLabel}}
</template>

<style>

  .locale-switcher {
    display: inline-block;
  }

</style>
