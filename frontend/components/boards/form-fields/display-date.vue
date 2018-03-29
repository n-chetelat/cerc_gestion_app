<script>
import * as moment from 'moment'

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

export default {
  name: "DisplayDate",
  mixins: [DisplayFieldMixin],
  computed: {
    formattedDate() {
      return moment(this.field.value).format("D MMMM YYYY")
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
