<script>

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

export default {
  name: "DisplaySelect",
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
div.display-select
  label {{field.label}}
  span {{calculatedValue}}

</template>

<style>

</style>
