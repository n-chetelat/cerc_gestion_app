<script>

import DisplayFieldMixin from "../../../../mixins/display-field-mixin.js"

export default {
  name: "DisplayMonth",
  mixins: [DisplayFieldMixin],
  computed: {
    calculatedValue() {
      return this.choicesById &&
        this.choicesById[this.field.value] &&
        this.choicesById[this.field.value].label
    }
  }
}
</script>

<template lang="pug">
div.display-month
  label {{field.label}}
  span {{calculatedValue}}

</template>

<style>

</style>
