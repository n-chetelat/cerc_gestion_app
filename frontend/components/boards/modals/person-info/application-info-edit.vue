<script>

import { mapActions } from "vuex"
import { keyBy } from "lodash-es"

import InputText from '../../../shared/form-fields/input/input-text.vue'
import InputUploadSingle from '../../../shared/form-fields/input/input-upload-single.vue'
import InputUploadMultiple from '../../../shared/form-fields/input/input-upload-multiple.vue'
import InputTextarea from '../../../shared/form-fields/input/input-textarea.vue'
import InputCheckbox from '../../../shared/form-fields/input/input-checkbox.vue'
import InputRadio from '../../../shared/form-fields/input/input-radio.vue'
import InputDate from '../../../shared/form-fields/input/input-date.vue'
import InputSelect from '../../../shared/form-fields/input/input-select.vue'
import InputMonth from '../../../shared/form-fields/input/input-month.vue'
import InputSemester from '../../../shared/form-fields/input/input-semester.vue'

export default {
  name: "ApplicationInfoEdit",
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
      formIsValid: false,
      loading: false,
    }
  },
  mounted() {
    this.calculateFormIsValid()
  },
  computed: {
    formFieldsById() {
      return keyBy(this.application.form_fields, "id")
    }
  },
  methods: {
    ...mapActions("application", ["updateApplication"]),
    calculateFormIsValid() {
      const fieldsValid = this.$refs.field.every((field) => field.isValid)
      this.formIsValid = this.application && fieldsValid
    },
    getSavedValue(field) {
      const formField = this.formFieldsById[field.id]
      if (formField) return formField.value
    },
    async saveApplication() {
      if (!this.formIsValid || this.loading) return
      this.loading = true
      await this.updateApplication({applicationId: this.application.id,
        values: this.$refs.field
      }
    ).then(({data}) => {
        this.$emit("update", data)
      }).catch(() => {
        this.$emit("error")
      })
      this.loading = false
    },
  },
  components: {
    InputText,
    InputDate,
    InputRadio,
    InputSelect,
    InputMonth,
    InputSemester,
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
      component.field-row(
        ref="field", v-for="field in applicationForm.form",
        :is="field.type", :label="field.label", :options="field.options",
        :field-id="field.id", :field-type="field.type", :class="{'mandatory': !field.options.optional}",
        @input="calculateFormIsValid", :saved-value="getSavedValue(field)"
      )
      button.submit(type="button", :disabled="!formIsValid", @click="saveApplication", :class="{'--disabled': !formIsValid}") Save


</template>

<style>

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
