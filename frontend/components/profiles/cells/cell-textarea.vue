<script>

import CellFieldMixin from "mixins/cell-field-mixin"
import { mixin as clickaway } from 'vue-clickaway'

export default {
  name: "CellTextarea",
  mixins: [CellFieldMixin, clickaway],
  data() {
    return {
      editing: false
    }
  },
  computed: {
  },
  methods: {
    setNewValue(event) {
      this.updateValue(event, event.target.innerText)
    },
    closeEditing() {
      this.editing = false
    },
  }
}
</script>

<template lang="pug">
  span.cell-textarea(
    @dblclick="editing = true",
    :contenteditable="editing",
    :class="{'--editing': editing}",
    v-on-clickaway="closeEditing",
    @blur="setNewValue($event)") {{field.value}}

</template>

<style>

</style>
