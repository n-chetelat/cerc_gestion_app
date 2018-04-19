<script>

import { keyBy } from "lodash-es"

import DisplayText from "../../form-fields/display-text.vue"
import DisplayTextarea from "../../form-fields/display-textarea.vue"
import DisplayDate from "../../form-fields/display-date.vue"
import DisplayRadio from "../../form-fields/display-radio.vue"
import DisplaySelect from "../../form-fields/display-select.vue"
import DisplayCheckbox from "../../form-fields/display-checkbox.vue"
import DisplayUploadSingle from "../../form-fields/display-upload-single.vue"
import DisplayUploadMultiple from "../../form-fields/display-upload-multiple.vue"

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
