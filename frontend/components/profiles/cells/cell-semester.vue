<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellMonth",
  mixins: [CellFieldMixin],
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
  span.cell-semester {{calculatedValue}}

</template>

<style>

</style>
