<script>

import { keyBy } from "lodash-es"

import DisplayText from "../../../shared/form-fields/display/display-text.vue"
import DisplayTextarea from "../../../shared/form-fields/display/display-textarea.vue"
import DisplayDate from "../../../shared/form-fields/display/display-date.vue"
import DisplayRadio from "../../../shared/form-fields/display/display-radio.vue"
import DisplaySelect from "../../../shared/form-fields/display/display-select.vue"
import DisplayMonth from "../../../shared/form-fields/display/display-month.vue"
import DisplaySemester from "../../../shared/form-fields/display/display-semester.vue"
import DisplayCheckbox from "../../../shared/form-fields/display/display-checkbox.vue"
import DisplayUploadSingle from "../../../shared/form-fields/display/display-upload-single.vue"
import DisplayUploadMultiple from "../../../shared/form-fields/display/display-upload-multiple.vue"

export default {
  name: "ApplicationInfoDisplay",
  props: {
    person: {
      required: true
    },
    application: {
      required: true
    },
    applicationForm: {
      required: true
    }
  },
  data() {
    return {
    }
  },
  computed: {
    applicationFormFieldsById() {
      return keyBy(this.applicationForm.form, "id")
    },
  },
  methods: {
    getOptions(field) {
      const value = this.applicationFormFieldsById[field.id]
      return value && value.options
    }
  },
  components: {
    DisplayText,
    DisplayDate,
    DisplayRadio,
    DisplaySelect,
    DisplayMonth,
    DisplaySemester,
    DisplayTextarea,
    DisplayCheckbox,
    DisplayUploadSingle,
    DisplayUploadMultiple,
  }
}
</script>

<template lang="pug">
  div.application-info-display
    div.display-fields
      component.field-row(v-for="field in application.form_fields", :is="`display-${field.type}`", :field="field", :options="getOptions(field)")


</template>

<style>


  .application-info-display {
  }

</style>
