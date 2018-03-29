<script>

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

export default {
  name: "DisplayText",
  mixins: [DisplayFieldMixin],
}
</script>

<template lang="pug">
  div.display-text
    label {{field.label}}
    span {{field.value}}

</template>

<style scoped>

</style>
