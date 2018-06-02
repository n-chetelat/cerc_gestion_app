<script>
import FormFieldMixin from "../../../../mixins/form-field-mixin.js"

export default {
  name: "InputSemester",
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
  div.input-semester
    label.label {{label}}
    select(v-model="value", @change="onInput")
      option(:value="null") --
      option(v-for="choice in options.choices", :value="choice.id") {{choice.label}}
</template>

<style>
</style>
