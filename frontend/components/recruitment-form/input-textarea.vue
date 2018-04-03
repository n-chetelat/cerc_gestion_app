<script>
import FormFieldMixin from "../../mixins/form-field-mixin.js"

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
  .input-textarea textarea {
    width: 20em;
    min-height: 10em;
  }

</style>
