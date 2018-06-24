<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellText",
  mixins: [CellFieldMixin],
}
</script>

<template lang="pug">
  span.cell-text {{field.value}}

</template>

<style scoped>

</style>
