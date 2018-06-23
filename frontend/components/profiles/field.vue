<script>

import { mapGetters } from "vuex"

import CellText from "components/profiles/cells/cell-text.vue"
import CellTextarea from "components/profiles/cells/cell-textarea.vue"
import CellDate from "components/profiles/cells/cell-date.vue"
import CellRadio from "components/profiles/cells/cell-radio.vue"
import CellSelect from "components/profiles/cells/cell-select.vue"
import CellMonth from "components/profiles/cells/cell-month.vue"
import CellSemester from "components/profiles/cells/cell-semester.vue"
import CellCheckbox from "components/profiles/cells/cell-checkbox.vue"

export default {
  name: "Field",
  props: {
    profile: {required: true},
    field: {required: true},
  },
  data() {
    return {
    }
  },
  computed: {
    ...mapGetters("profiles", ["profileFieldValuesByProfileId"]),
    profileFieldData() {
      const data = this.profileFieldValuesByProfileId[this.profile.id][this.field.id]
      return data ? data.value : null
    },
    fieldDataWithMetadata() {
      const value = this.profileFieldValuesByProfileId[this.profile.id][this.field.id]
      return { ...value, ...this.field }
    }
  },
  components: {
    CellText,
    CellDate,
    CellRadio,
    CellSelect,
    CellMonth,
    CellSemester,
    CellTextarea,
    CellCheckbox,
  }
}
</script>

<template lang="pug">
  span.field
    component(:is="`cell-${field.form}`", :field="fieldDataWithMetadata")



</template>

<style>


</style>
