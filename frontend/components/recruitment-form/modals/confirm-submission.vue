<script>

import { mapGetters, mapActions } from "vuex"

import { map } from "lodash-es"

import Modal from "../../shared/modal.vue"

import DisplayText from "../../shared/form-fields/display/display-text.vue"
import DisplayTextarea from "../../shared/form-fields/display/display-textarea.vue"
import DisplayDate from "../../shared/form-fields/display/display-date.vue"
import DisplayRadio from "../../shared/form-fields/display/display-radio.vue"
import DisplaySelect from "../../shared/form-fields/display/display-select.vue"
import DisplayCheckbox from "../../shared/form-fields/display/display-checkbox.vue"
import DisplayUploadSingle from "../../shared/form-fields/display/display-upload-single.vue"
import DisplayUploadMultiple from "../../shared/form-fields/display/display-upload-multiple.vue"

export default {
  name: "ConfirmSubmission",
  props: {
    recruitmentFormInput: {
      required: true
    },
  },
  data() {
    return {
      translations: {
        title: {
          en: "Confirmation", fr: "Confirmation"
        },
        subtitle: {en: "Please review your information before submitting",
          fr: "Veuillez relire votre information avant de la soumettre"
        },
        confirm: {en: "Confirm", fr: "Confirmer"}
      }
    }
  },
  computed: {
    ...mapGetters("locales", ["currentLocale"]),
    recruitmentFormFields() {
      return map(this.recruitmentFormInput, (input) => {
        const {fieldType, label, value, fieldId, options} = input
        return {
          type: fieldType.replace(/^input-/, ""),
          label, value, fieldId, options
        }
      })
    }
  },
  methods: {
    closeModal() {
      this.$emit("close")
    },
    submitApplication() {
      this.$emit("confirm")
    },
  },
  components: {
    Modal,
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
  modal(@close="closeModal")
    template(slot="header")
      div.confirm-submission-heading
        h1 {{translations.title[currentLocale]}}
        h2 {{translations.subtitle[currentLocale]}}
    template(slot="body")
      div.confirm-submission
        component.field-row(v-for="field in recruitmentFormFields", :is="`display-${field.type}`", :field="field", :options="field.options")
        button.submit(@click="submitApplication") {{translations.confirm[currentLocale]}}

</template>

<style>

  @import "../../../init/variables.css";


  .confirm-submission-heading {
    text-align: center;
    & h2 {
      font-size: 1.1em;
    }
  }

  .confirm-submission {
    min-height: 300px;
    max-height: var(--windowHeight)px;
    overflow: auto;
    padding: 2em 2em;
    width: 90%;
    margin: auto;

    & .field-row {
      padding: .5em;
      padding-top: 0;
      margin: .5em;
      display: flex;

      & label {
        display: inline-block;
        vertical-align: top;
        font-weight: bold;
        width: 40%;
        padding: 2px 0;
        padding-right: 2em;
        text-align: right;
      }
      & ul {
        display: inline-block;
        list-style: none;
        padding: 0;
        margin: 0;
      }
      & ul.file-list {
        display: block;
        margin: auto;
      }
      & a {
        color: black;
        &:hover {
          text-decoration: none;
        }
      }
      & .pdf-icon {
        width: 32px;
        height: 32px;
        display: inline-block;
        background: url("../../../static/icons/file-pdf.svg") left bottom / 70% no-repeat;
      }

      &.display-textarea span {
        width: 60%;
        white-space: pre-wrap;
      }
    }

    & .submit {
      margin-top: 3em;
    }

  }

  @media screen and (max-width: 400px) {
      .confirm-submission .field-row {
        flex-direction: column;
        & label {
          width: 100%;
          padding: 0;
          text-align: left;
        }
        &.display-textarea span {
          width: 100%;
          overflow: auto;
        }
      }
  }

</style>
