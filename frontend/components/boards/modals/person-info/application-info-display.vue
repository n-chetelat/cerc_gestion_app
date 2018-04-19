<script>

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
    }
  },
  data() {
    return {
    }
  },
  computed: {
  },
  methods: {
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
    div.field-row
      label Name
      span {{person.name}}
    div.field-row
      label Lastname
      span {{person.lastname}}
    div.field-row
      label Email
      span {{person.email}}
    div.field-row
      label For position
      span {{application.position}}
    div.field-row
      label Starting on
      span {{application.starting_semester}}
    div.display-fields
      component.field-row(v-for="field in application.form_fields", :is="`display-${field.type}`", :field="field")


</template>

<style>

  :root {

  }

  .application-info-display {
  }

</style>
