<script>

import FormFieldMixin from "../../mixins/form-field-mixin.js"

export default {
  name: "InputText",
  mixins: [FormFieldMixin],
  computed: {
    isValid() {
      if (this.options.optional) return true
      if (this.fieldId === "email") {
        return !!(this.value && this.value.match(/\w[\w.-]+@[\w.-]+\.[\w.-]+\w$/))
      } else {
        return !!this.value
      }
    }
  }
}
</script>

<template lang="pug">
  div.input-text
    label.label {{label}}
    input(type="text", v-model="value", @input="onInput")
</template>

<style>
.input-text input {
  width: 20em;
}

</style>
