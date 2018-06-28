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
      }
    },
  },
  methods: {
    ...mapActions("profiles", ["updatePersonData"]),
    calculatedFieldDataFor(fieldName) {
      return this.calculatedFieldData[fieldName]
    },
    async updateValue(event, newValue) {
      if (!this.inputIsValid(event.target.innerText)) {
        this.emitValid(event, false)
        return
      }
      this.emitValid(event, true)
      if (this.valueNotChanged(event.target.innerText)) return

      const payload = {
        personId: this.profile.uuid,
        field: this.fieldName,
        newValue: (this.choices.length ? this.fieldChoice : event.target.innerText)
      }
      try {
        await this.updatePersonData(payload)
      } catch(err) {
        this.$emit("error")
      }
    },
    emitValid(event, value) {
      // let isValid = value
      // if (this.fieldName === "email") {
      //   isValid = value && event.target.innerText.match(/\w[\w.-]+@[\w.-]+\.[\w.-]+\w$/)
      // }
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

    component.field-cell(v-else, :is="`cell-${calculatedFieldDataFor(fieldName).form}`",
      :profile="profile", :field="calculatedFieldDataFor(fieldName)", @error="$emit('error')", @valid="emitValid")

</template>

<style>

  @import "../../init/variables.css";

  .static-field {
    @apply --field-style;
    & .field-cell {
      @apply --field-cell-style;
      z-index: 10;

    }
  }

</style>
