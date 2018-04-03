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
  },
  computed: {
    isValid() {
      if (!this.options.optional) {
        return !!this.value.length
      }
      return true
    }
  }
}
</script>

<template lang="pug">
  div.input-checkbox
    label.label {{label}}
    fieldset.choice-group
      span(v-for="choice in options.choices")
        label.check {{choice.label}}
        input(type="checkbox", :value="choice.id", v-model="value", @change="onInput")
</template>

<style>

</style>
