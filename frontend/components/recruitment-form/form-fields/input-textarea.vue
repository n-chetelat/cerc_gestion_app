<script>
import FormFieldMixin from "../../../mixins/form-field-mixin.js"

export default {
  name: "InputTextarea",
  mixins: [FormFieldMixin],
}
</script>

<template lang="pug">
  div.input-textarea
    label.label {{label}}
    textarea(v-model="value", @change="onInput")
</template>

<style>

  :root {
    --textFamily: 'Open Sans', Arial, sans-serif;
  }

  .input-textarea textarea {
    font-family: var(--textFamily);
    font-size: .9em;
    line-height: 1.3em;
    min-height: 10em;
  }

</style>
