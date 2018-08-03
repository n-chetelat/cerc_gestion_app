<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellText",
  mixins: [CellFieldMixin],
  data() {
    return {
      textValue: this.field.value
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
      this.updateValue(event, this.textValue)
    }
  }
}
</script>

<template lang="pug">
  span.cell-text
    span.cell-display(v-if="!editing", @dblclick="editing = true") {{displayValue}}
    input(v-else, type="text", v-model="textValue", v-on-clickaway="closeEditing", @blur="setNewValue($event)")

</template>

<style>



</style>
