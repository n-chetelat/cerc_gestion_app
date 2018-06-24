<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellTextarea",
  mixins: [CellFieldMixin],
}
</script>

<template lang="pug">
  span.cell-textarea {{field.value}}

</template>

<style>

@import "../../../init/variables.css";

  .cell-textarea {
    overflow-y: auto;
    overflow-x: hidden;
    font-family: var(--textFamily);
    font-size: .9em;
    line-height: 1.3em;
    display: inline-block;
    width: 20em;
  }

</style>
