<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellRadio",
  mixins: [CellFieldMixin],
  data() {
    return {
      fieldChoice: this.field.value,
    }
  },
  computed: {
    displayValue() {
      return this.choicesById &&
        this.choicesById[this.field.value] &&
        this.choicesById[this.field.value].label
    }
  }
}
</script>

<template lang="pug">
  span.cell-radio
    span.cell-display(v-if="!editing", @dblclick="editing = true") {{displayValue}}
    select(v-else, v-model="fieldChoice", @change="updateValue($event, fieldChoice)", v-on-clickaway="closeEditing")
      option(v-for="choice in field.choices", :value="choice.id") {{choice.label}}

</template>

<style>

</style>
