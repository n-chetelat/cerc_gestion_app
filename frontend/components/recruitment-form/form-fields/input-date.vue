<script>
import FormFieldMixin from "../../../mixins/form-field-mixin.js"

export default {
  name: "InputDate",
  mixins: [FormFieldMixin],
}
</script>

<template lang="pug">
  div.input-date
    label.label {{label}}
    input(type="date", v-model="value", @change="onInput")
</template>

<style>

</style>
