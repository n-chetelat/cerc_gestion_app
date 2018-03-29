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
  span {{field.value}}

</template>

<style>

</style>
