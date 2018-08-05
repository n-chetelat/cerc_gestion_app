<script>

import { mapGetters, mapActions } from "vuex"

import CellText from "components/profiles/cells/cell-text.vue"
import CellMonth from "components/profiles/cells/cell-month.vue"
import CellSemester from "components/profiles/cells/cell-semester.vue"
import CellSelect from "components/profiles/cells/cell-select.vue"

export default {
  name: "StaticField",
  props: {
    profile: {required: true},
    fieldName: {required: true},
  },
  data() {
    return {
      fieldChoice: this.profile[this.fieldName],
    }
  },
  computed: {
    ...mapGetters("positions", ["allPositions"]),
    calculatedFieldData() {
      return {
        name: {form: "text", optional: false, value: this.profile.name, fieldName: "name"},
        lastname: {form: "text", optional: false, value: this.profile.lastname, fieldName: "lastname"},
        position_id: {form: "select", optional: false, value: this.profile.position_id, fieldName: "position_id",
          choices: this.allPositions.map(p => { p.label = p.title; return p })},
        email: {form: "text", optional: false, value: this.profile.email, fieldName: "email"},
        starting_date: {form: this.profile.starting_date_type, optional: false, fieldName: "starting_date",
          value: this.profile.starting_date, starting_date_label: this.profile.starting_date_label},
        ending_date: {form: this.profile.starting_date_type, optional: false, fieldName: "ending_date",
          value: this.profile.ending_date, ending_date_label: this.profile.ending_date_label},
        applied_at: {form: "text", optional: false, fieldName: "applied_at",
          value: this.profile.applied_at, editable: false},
        closed_at: {form: "text", optional: false, fieldName: "closed_at",
          value: this.profile.closed_at, editable: false}
      }
    },
  },
  methods: {
    ...mapActions("profiles", ["updatePersonData"]),
    calculatedFieldDataFor(fieldName) {
      return this.calculatedFieldData[fieldName]
    },
    emitValid(event, value) {
      this.$emit("valid", event, value)
    }
  },
  components: {
    CellText,
    CellMonth,
    CellSemester,
    CellSelect,
  }
}
</script>

<template lang="pug">
  span.static-field

    component.field-cell(v-if="fieldName === 'starting_date'", :is="`cell-${profile.starting_date_type}`",
      :profile="profile", :field="calculatedFieldDataFor('starting_date')", @error="$emit('error')", @valid="emitValid")
    component.field-cell(v-if="fieldName === 'ending_date'", :is="`cell-${profile.starting_date_type}`",
      :profile="profile", :field="calculatedFieldDataFor('ending_date')", @error="$emit('error')", @valid="emitValid")

    component.field-cell(v-else, :is="`cell-${calculatedFieldDataFor(fieldName).form}`",
      :class="{'not-editable': calculatedFieldDataFor(fieldName).editable === false}",
      :profile="profile", :field="calculatedFieldDataFor(fieldName)", :editable="calculatedFieldDataFor(fieldName).editable", @error="$emit('error')", @valid="emitValid")

</template>

<style>

  @import "../../init/variables.css";

  .static-field {
    @apply --field-style;
    & .field-cell {
      @apply --field-cell-style;
    }
    .not-editable {
      color: color(var(--textColor) tint(50%));
    }
  }

</style>
