<script>
import FormFieldMixin from "../../../mixins/form-field-mixin.js"

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
      span.input(v-for="choice in options.choices")
        input(type="radio", :value="choice.id", v-model="value", @change="onInput")
        label.radio {{choice.label}}
</template>

<style>

.input-radio {
  & .input {
    display: flex;
    & label {
      width: 90%;
    }
    & input {
      display: inline;
      width: 1em;
      margin-top: .5em;
    }
  }
}

</style>
