<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellText",
  mixins: [CellFieldMixin],
  computed: {
    isValid() {
      return true
    },
    displayValue() {
      return this.field.value
    },
  },
  methods: {
    setNewValue(event) {
      this.updateValue(event, event.target.innerText).then(() => {
        //Set text value manually due to bug that duplicates text
        event.target.innerText = this.displayValue
      })
    }
  }
}
</script>

<template lang="pug">
  span.cell-text
    span.cell-display(contenteditable, @blur="setNewValue($event)") {{displayValue}}

</template>

<style>

</style>
