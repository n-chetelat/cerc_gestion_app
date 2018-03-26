<script>
import FormFieldMixin from "../../mixins/form-field-mixin.js"

export default {
  name: "InputSelect",
  mixins: [FormFieldMixin],
  props: {
    options: {
      type: Object,
      default: function () {
        return { choices: [] }
      }
    }
  },
}
</script>

<template lang="pug">
  div.input-select
    label.label {{label}}
    select(v-model="value")
      option(:value="null") --
      option(v-for="choice in options.choices", :value="choice.id") {{choice.label}}
</template>

<style>
</style>
