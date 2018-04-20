<script>

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

export default {
  name: "DisplayCheckbox",
  mixins: [DisplayFieldMixin],
  methods: {
    calculatedValue(val) {
      return this.choicesById &&
        this.choicesById[val] &&
        this.choicesById[val].label
    }
  }
}
</script>

<template lang="pug">
  div.display-checkbox
    label {{field.label}}
    ul
      li.value(v-for="val in field.value") {{calculatedValue(val)}}

</template>

<style scoped>

</style>
