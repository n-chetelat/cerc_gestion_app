<script>

import { mapActions } from "vuex"
import { keyBy } from "lodash-es"

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
      button.submit(type="button", :disabled="!formIsValid", @click="saveApplication") Save


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
