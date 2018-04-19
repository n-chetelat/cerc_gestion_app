<script>

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

export default {
  name: "DisplaySelect",
  mixins: [DisplayFieldMixin],
}
</script>

<template lang="pug">
div.display-select
  label {{field.label}}
  span {{choicesById[field.value].label}}

</template>

<style>

</style>
