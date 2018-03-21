<script>
import FormFieldMixin from "../../mixins/form-field-mixin.js"

export default {
  name: "InputCheckbox",
  mixins: [FormFieldMixin],
  props: {
    options: {
      type: Object,
      default: function () {
        return { choices: [] }
      }
    }
  },
  data() {
    return {
      value: []
    }
  }
}
</script>

<template lang="pug">
  div.input-checkbox
    label.label {{label}}
    fieldset
      span(v-for="choice in options.choices")
        label.check {{choice.label}}
        input(type="checkbox", :value="choice.id", v-model="value")
</template>

<style>
  .input-checkbox fieldset {
    display: inline-block;
    max-width: 20em;
    border: none;
  }

  .input-checkbox label.check {
    margin: 5px 5px 0 15px;
    display: inline-block;
  }
</style>
