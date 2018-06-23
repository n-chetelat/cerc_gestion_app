<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellText",
  mixins: [CellFieldMixin],
}
</script>

<template lang="pug">
  div.cell-text
    span {{field.value}}

</template>

<style scoped>

</style>
