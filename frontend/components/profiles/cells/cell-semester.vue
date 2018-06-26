<script>

import { mapGetters } from "vuex"

import { keyBy } from "lodash-es"

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellSemester",
  mixins: [CellFieldMixin],
  data() {
    return {
      fieldChoice: this.field.value,
    }
  },
  computed: {
    ...mapGetters("dates", ["semesters"]),
    choicesById() {
      if (!this.semesters.length) return {}
      return keyBy(this.semesters, "id")
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
  span.cell-semester(v-if="semesters.length")
    span.cell-display(v-if="!editing", @dblclick="editing = true") {{displayValue}}
    select(v-else, v-model="fieldChoice", @change="updateValue($event, fieldChoice)", v-on-clickaway="closeEditing")
      option(v-for="choice in semesters", :value="choice.id") {{choice.label}}

</template>

<style>

</style>
