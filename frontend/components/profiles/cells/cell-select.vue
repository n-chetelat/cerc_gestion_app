<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellSelect",
  mixins: [CellFieldMixin],
  data() {
    return {
      fieldChoice: this.field.value,
    }
  },
  computed: {
    isValid() {
      const inChoices =  this.field.choices.map(s => s.id).includes(this.fieldChoice)
      if (this.field.optional) return !this.fieldChoice || inChoices
      else return this.fieldChoice && inChoices
    },
    displayValue() {
      return this.choicesById &&
        this.choicesById[this.field.value] &&
        this.choicesById[this.field.value].label
    }
  }
}
</script>

<template lang="pug">
  span.cell-select
    span.cell-display(v-if="!editing", @dblclick="editing = true") {{displayValue}}
    select(v-else, v-model="fieldChoice", @change="updateValue($event, fieldChoice)", v-on-clickaway="closeEditing")
      option(v-for="choice in field.choices", :value="choice.id") {{choice.label}}

</template>

<style>

</style>
