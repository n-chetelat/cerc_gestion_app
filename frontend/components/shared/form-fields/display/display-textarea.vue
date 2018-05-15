<script>

import DisplayFieldMixin from "../../../../mixins/display-field-mixin.js"

export default {
  name: "DisplayTextarea",
  mixins: [DisplayFieldMixin],
}
</script>

<template lang="pug">
  div.display-textarea
    label {{field.label}}
    span {{field.value}}

</template>

<style>

@import "../../../../init/variables.css";

  .display-textarea {
    & span {
      font-family: var(--textFamily);
      font-size: .9em;
      line-height: 1.3em;
      display: inline-block;
      width: 30em;
    }
  }

</style>
