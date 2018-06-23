<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellTextarea",
  mixins: [CellFieldMixin],
}
</script>

<template lang="pug">
  div.cell-textarea
    span {{field.value}}

</template>

<style>

@import "../../../init/variables.css";

  .cell-textarea {
    & span {
      font-family: var(--textFamily);
      font-size: .9em;
      line-height: 1.3em;
      display: inline-block;
      width: 30em;
    }
  }

</style>
