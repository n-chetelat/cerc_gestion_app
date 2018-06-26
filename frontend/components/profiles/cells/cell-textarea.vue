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
        return this.editing ? this.field.value : `${this.field.value.substring(0, 40)}...`
      }
    }
  },
  methods: {
    setNewValue(event) {
      this.closeEditing()
      this.updateValue(event, event.target.innerText)
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
