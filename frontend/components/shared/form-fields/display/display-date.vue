<script>
import * as moment from 'moment'

import DisplayFieldMixin from "../../../../mixins/display-field-mixin.js"

export default {
  name: "DisplayDate",
  mixins: [DisplayFieldMixin],
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
  div.display-date
    label {{field.label}}
    span {{formattedDate}}

</template>

<style scoped>

</style>
