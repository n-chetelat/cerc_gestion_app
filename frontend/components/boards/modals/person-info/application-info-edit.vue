<script>

import { mapGetters, mapActions } from 'vuex'

import InputText from '../../../recruitment-form/form-fields/input-text.vue'
import InputUploadSingle from '../../../recruitment-form/form-fields/input-upload-single.vue'
import InputUploadMultiple from '../../../recruitment-form/form-fields/input-upload-multiple.vue'
import InputTextarea from '../../../recruitment-form/form-fields/input-textarea.vue'
import InputCheckbox from '../../../recruitment-form/form-fields/input-checkbox.vue'
import InputRadio from '../../../recruitment-form/form-fields/input-radio.vue'
import InputDate from '../../../recruitment-form/form-fields/input-date.vue'
import InputSelect from '../../../recruitment-form/form-fields/input-select.vue'

export default {
  name: "ApplicationInfoEdit",
  props: {
    application: {
      required: true
    },
  },
  data() {
    return {
      applicationForm: null,
      formIsValid: false
    }
  },
  async created() {
    await this.getPositionForm(this.application.position_id)
    await this.getAllPositions()
    this.applicationForm = this.positionFormsById[this.application.position_id]
  },
  computed: {
    ...mapGetters("positions", ["allPositions", "positionFormsById"]),
    positionSelectField() {
      return {
        id:"starting_semester",
        label:"Starting Semester",
        options: { choices: this.allPositions.map((p) => {
          p.label = p.title
          return p
        }) },
        type:"input-select"
      }
    }
  },
  methods: {
    ...mapActions("positions", ["getAllPositions", "getPositionForm"]),
    calculateFormIsValid() {
      const fieldsValid = this.$refs.field.every((field) => field.isValid)
      this.formIsValid = this.application && fieldsValid
    },
  },
  components: {
    InputText,
    InputDate,
    InputRadio,
    InputSelect,
    InputTextarea,
    InputCheckbox,
    InputUploadSingle,
    InputUploadMultiple,
  }
}
</script>

<template lang="pug">
  div.application-info-display
    div(v-if="applicationForm")
      input-select.field-row(
        ref="field", :label="positionSelectField.label", :options="positionSelectField.options",
        :field-id="positionSelectField.id", :field-type="positionSelectField.type", :class="{'mandatory': !positionSelectField.options.optional}",
        @input="calculateFormIsValid"
      )
      component.field-row(
        ref="field", v-for="field in applicationForm.form",
        :is="field.type", :label="field.label", :options="field.options",
        :field-id="field.id", :field-type="field.type", :class="{'mandatory': !field.options.optional}",
        @input="calculateFormIsValid"
      )
      button(type="button", :disabled="!formIsValid") Save


</template>

<style>

  :root {

  }

  .application-info-display {
    & .choice-group label {
      background-color: transparent;
      text-align: left;
      font-weight: normal;
    }

    & .file-list {
      list-style: none;
      padding-left: 0;
      margin: auto;
    }
  }

</style>
