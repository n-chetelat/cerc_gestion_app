<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellTextarea",
  mixins: [CellFieldMixin],
  data() {
    return {
    }
  },
  computed: {
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
      this.updateValue(event, event.target.innerText).then(() => {
        //Set text value manually due to bug that duplicates text
        event.target.innerText = this.displayValue
      })
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
