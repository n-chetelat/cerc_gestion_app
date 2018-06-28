<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellText",
  mixins: [CellFieldMixin],
  data() {
    return {
      textValue: null
    }
  },
  computed: {
    displayValue() {
      return this.field.value
    },
    isValid() {
      if (this.field.fieldName === "email") {
        return !!(this.textValue && this.textValue.match(/\w[\w.-]+@[\w.-]+\.[\w.-]+\w$/))
      }

      if (!this.field.optional) {
        return !!(this.textValue && this.textValue.length)
      }
      return true
    }
  },
  methods: {
    setNewValue(event) {
      this.textValue = event.target.innerText.trim()
      this.updateValue(event, this.textValue)
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
