<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellText",
  mixins: [CellFieldMixin],
  computed: {
    isValid() {
      return true
    }
  },
  methods: {
    setNewValue(event) {
      this.updateValue(event, event.target.innerText)
    }
  }
}
</script>

<template lang="pug">
  span.cell-text(contenteditable, @blur="setNewValue($event)") {{field.value}}

</template>

<style scoped>

</style>
