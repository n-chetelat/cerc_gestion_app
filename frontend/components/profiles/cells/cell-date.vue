<script>
import * as moment from 'moment'
import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellDate",
  mixins: [CellFieldMixin],
  computed: {
    formattedDate() {
      let date =  moment(this.field.value).format("D MMMM YYYY")
      if (date === "Invalid date") { date = null }
      return date
    }
  }
}
</script>

<template lang="pug">
  span.cell-date {{formattedDate}}

</template>

<style scoped>

</style>
