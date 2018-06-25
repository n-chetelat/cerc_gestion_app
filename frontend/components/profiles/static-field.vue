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
    }
  },
  computed: {
    ...mapGetters("positions", ["allPositionsById"]),
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
    }
  },
  methods: {
    ...mapActions("profiles", ["updatePersonData"]),
    async updateValue(event) {
      if (event.target.innerText === this.value) {
        return
      }
      const payload = {
        personId: this.profile.uuid,
        field: this.fieldName,
        newValue: event.target.innerText
      }
      try {
        await this.updatePersonData(payload)
      } catch(err) {
        this.$emit("error")
      }
    },

  }
}
</script>

<template lang="pug">
  span.static-field
    span.field-cell(:contenteditable="isEditable", @blur="updateValue($event)") {{displayValue}}

</template>

<style scoped>

  @import "../../init/variables.css";

  .static-field {
    @apply --field-style;
    & .field-cell {
      @apply --field-cell-style
    }
  }

</style>
