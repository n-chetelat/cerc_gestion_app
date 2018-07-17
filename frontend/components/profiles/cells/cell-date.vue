<script>
import * as moment from 'moment'
import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellDate",
  mixins: [CellFieldMixin],
  data() {
    return {
      dateChosen: this.field.value
    }
  },
  computed: {
    isValid() {
      if (!this.field.optional) {
        return !!this.dateChosen
      }
      return true
    },
    formattedDate() {
      if (!this.field.value) return null
      let date =  moment(this.field.value).format("D MMMM YYYY")
      if (date === "Invalid date") { date = null }
      return date
    }
  }
}
</script>

<template lang="pug">
  span.cell-date
    span.cell-display(v-if="!editing", @dblclick="editing = true") {{formattedDate}}
    input(v-else, type="date", v-model="dateChosen", @change="updateValue($event, dateChosen)", v-on-clickaway="closeEditing")

</template>

<style scoped>

</style>
