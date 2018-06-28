<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellTextarea",
  mixins: [CellFieldMixin],
  data() {
    return {
      textValue: null,
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
      this.textValue = event.target.innerText.trim()
      this.closeEditing()
      this.updateValue(event, this.textValue)
    },
  }
}
</script>

<template lang="pug">
  span.cell-textarea(
    :contenteditable="editing",
    :class="{'--editing': editing}",
    v-on-clickaway="closeEditing",
    @dblclick="editing = true",
    @blur="setNewValue($event)")
    span.cell-display {{displayValue}}

</template>

<style>

</style>
