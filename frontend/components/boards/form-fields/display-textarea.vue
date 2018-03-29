<script>

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

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

  .display-textarea {
    & span {
      display: inline-block;
      width: 30em;
    }
  }

</style>
