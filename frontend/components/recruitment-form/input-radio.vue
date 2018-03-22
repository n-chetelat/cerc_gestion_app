<script>
import FormFieldMixin from "../../mixins/form-field-mixin.js"

export default {
  name: "InputRadio",
  mixins: [FormFieldMixin],
  props: {
    options: {
      type: Object,
      default: function () {
        return { choices: [] }
      }
    }
  }
}
</script>

<template lang="pug">
  div.input-radio
    label.label {{label}}
    fieldset.choice-group
      span(v-for="choice in options.choices")
        label.radio {{choice.label}}
        input(type="radio", :value="choice.id", v-model="value")
</template>

<style>

</style>
