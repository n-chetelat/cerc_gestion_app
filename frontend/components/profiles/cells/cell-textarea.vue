<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellTextarea",
  mixins: [CellFieldMixin],
  data() {
    return {
      textValue: this.field.value,
    }
  },
  computed: {
    isValid() {
      if (!this.field.optional) {
        return !!(this.textValue && this.textValue.length)
      }
      return true
    },
    displayValue() {
      if (this.field.value) {
        const truncated = `${this.field.value.substring(0, 40)}${this.field.value.length > 40 ? '...' : ''}`
        return this.editing ? this.field.value : truncated
      }
    }
  },
  methods: {
    setNewValue(event) {
      this.closeEditing()
      this.updateValue(event, this.textValue)
    },
  }
}
</script>

<template lang="pug">

  span.cell-textarea
    span.cell-display(v-if="!editing", @dblclick="editing = true") {{displayValue}}
    textarea(v-else, v-model="textValue", v-on-clickaway="closeEditing", @blur="setNewValue($event)") {{textValue}}

</template>

<style>

</style>
