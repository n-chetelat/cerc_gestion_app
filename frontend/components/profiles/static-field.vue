<script>

import { mapGetters, mapActions } from "vuex"

export default {
  name: "StaticField",
  props: {
    profile: {required: true},
    fieldName: {required: true},
  },
  data() {
    return {
      editingField: false,
      fieldChoice: this.profile[this.fieldName],
    }
  },
  computed: {
    ...mapGetters("positions", ["allPositions", "allPositionsById"]),
    ...mapGetters("dates", ["semesters", "months"]),
    value() {
      return this.profile[this.fieldName]
    },
    displayValue() {
      if (this.fieldName === "position_id") {
        return this.allPositionsById[this.value] ?
          this.allPositionsById[this.value].title : null
      } else if (this.fieldName === "starting_date") {
        return this.profile.starting_date_label
      } else return this.value
    },
    isEditable() {
      return !["position_id", "starting_date"].includes(this.fieldName)
    },
    choices() {
      if (this.fieldName === "position_id") {
        return this.allPositions
      } else if (this.fieldName === "starting_date") {
        let collection = []
        if (this.profile.starting_date_type === "semester") collection = this.semesters
        if (this.profile.starting_date_type === "month") collection = this.months
        if (collection.findIndex(c => c.id === this.profile.starting_date) < 0) {
          collection = [{id: this.profile.starting_date, label: this.profile.starting_date_label}, ...collection]
        }
        return collection
      } else return []
    }
  },
  methods: {
    ...mapActions("profiles", ["updatePersonData"]),
    async updateValue(event) {
      if (!this.inputIsValid(event.target.innerText)) {
        this.$emit("valid", event, false)
        return
      }
      this.$emit("valid", event, true)
      if (event.target.innerText === this.value) return

      const payload = {
        personId: this.profile.uuid,
        field: this.fieldName,
        newValue: event.target.innerText || this.fieldChoice
      }
      try {
        await this.updatePersonData(payload)
      } catch(err) {
        this.$emit("error")
      }
    },
    inputIsValid(input) {
      if (this.choices.length) {
        return this.choices.map(ch => ch.id).includes(this.fieldChoice)
      } else if (this.fieldName === "email") {
        return !!(input && input.match(/\w[\w.-]+@[\w.-]+\.[\w.-]+\w$/))
      } else {
        return !!input
      }
    }
  }
}
</script>

<template lang="pug">
  span.static-field
    span.field-cell(v-if="isEditable", contenteditable, @blur="updateValue($event)") {{displayValue}}

    span.field-cell(v-else)
      select(v-model="fieldChoice", @change="updateValue($event)")
        option(v-for="choice in choices", :value="choice.id") {{choice.label || choice.title}}

</template>

<style scoped>

  @import "../../init/variables.css";

  .static-field {
    @apply --field-style;
    & .field-cell {
      @apply --field-cell-style;
      width: 100%;
      text-align: center;

      & select {
        min-width: 100%;
        width: 15em;
      }
    }
  }

</style>
