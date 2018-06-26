<script>

import { mapGetters, mapActions } from "vuex"

import { mixin as clickaway } from 'vue-clickaway'

export default {
  name: "StaticField",
  mixins: [clickaway],
  props: {
    profile: {required: true},
    fieldName: {required: true},
  },
  data() {
    return {
      fieldChoice: this.profile[this.fieldName],
      editing: false,
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
        const choice = this.choices.find(ch => ch.id === this.profile.starting_date)
        return choice && choice.label
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
    valueNotChanged(input="") {
      if (this.choices.length) {
        return (this.fieldChoice === this.value)
      } else {
        return (input === this.value)
      }
    },
    inputIsValid(input="") {
      if (this.choices.length) {
        return this.choices.map(ch => ch.id).includes(this.fieldChoice)
      } else if (this.fieldName === "email") {
        return !!(input && input.match(/\w[\w.-]+@[\w.-]+\.[\w.-]+\w$/))
      } else {
        return !!input
      }
    },
    closeEditing() {
      this.editing = false
    }
  }
}
</script>

<template lang="pug">
  span.static-field
    span.field-cell(v-if="isEditable", contenteditable, @blur="updateValue($event)") {{displayValue}}

    span.field-cell(v-else)
      span(v-if="!editing", @dblclick="editing = true") {{displayValue}}
      select(v-else, v-model="fieldChoice", @change="updateValue($event)", v-on-clickaway="closeEditing")
        option(v-for="choice in choices", :value="choice.id") {{choice.label || choice.title}}

</template>

<style scoped>

  @import "../../init/variables.css";

  .static-field {
    @apply --field-style;
    & .field-cell {
      @apply --field-cell-style;
      z-index: 10;
    }
  }

</style>
