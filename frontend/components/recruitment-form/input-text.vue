<script>

import FormFieldMixin from "../../mixins/form-field-mixin.js"

export default {
  name: "InputText",
  mixins: [FormFieldMixin],
}
</script>

<template lang="pug">
  div.input-text
    label.label {{label}}
    input(type="text", v-model="value")
</template>

<style>
.input-text input {
  width: 20em;
}

</style>
