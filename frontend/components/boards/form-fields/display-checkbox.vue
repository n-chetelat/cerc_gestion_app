<script>

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

export default {
  name: "DisplayCheckbox",
  mixins: [DisplayFieldMixin],
}
</script>

<template lang="pug">
  div.display-checkbox
    label {{field.label}}
    ul
      li.value(v-for="val in field.value") {{val}}

</template>

<style scoped>

</style>
