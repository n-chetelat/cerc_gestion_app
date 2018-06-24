<script>

import CellFieldMixin from "mixins/cell-field-mixin"


export default {
  name: "CellCheckbox",
  mixins: [CellFieldMixin],
  methods: {
    calculatedValue(val) {
      return this.choicesById &&
        this.choicesById[val] &&
        this.choicesById[val].label
    }
  }
}
</script>

<template lang="pug">
  span.cell-checkbox
    ul
      li.value(v-for="val in field.value") {{calculatedValue(val)}}

</template>

<style scoped>

  .cell-checkbox {
    & ul {
      display: inline-block;
    }
  }

</style>
