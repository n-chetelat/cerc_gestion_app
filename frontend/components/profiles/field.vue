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
      return { ...value, ...this.field, id: (value ? value.id : null), profile_field_id: this.field.id }
    }
  },
  methods: {
    emitValid(event, value) {
      this.$emit("valid", event, value)
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
    component.field-cell(:is="`cell-${field.form}`", :profile="profile", :field="fieldDataWithMetadata", @error="$emit('error')", @valid="emitValid")



</template>

<style>

  @import "../../init/variables.css";

  .field {
    display: flex;
    overflow-x: hidden;
    overflow-y: auto;
    & .field-cell {
      min-height: var(--cellMinHeight)px;
      min-width: var(--cellMinHeight)px;
      margin: 0 auto;
      text-align: center;

      & .cell-display {
        min-height: 1.5em;
        min-width: var(--cellWidth)em;
        display: inline-block;
      }
      & select, & input, & textarea {
        min-width: 100%;
        width: var(--cellWidth)em;
      }

      &.cell-textarea {
        font-family: var(--textFamily);
        font-size: .9em;
        line-height: 1.3em;
        display: inline-block;

      }
      &.--editing {
        max-height: 100%;
      }
    }

  }

</style>
