<script>
import { mapGetters, mapActions } from "vuex"
import { omitBy, map } from "lodash-es"

import SceneMixin from 'mixins/scene-mixin.js'
import ModalMixin from 'mixins/modal-mixin.js'

import LocaleSwitcher from './shared/locale-switcher.vue'

import InputText from './shared/form-fields/input/input-text.vue'
import InputUploadSingle from './shared/form-fields/input/input-upload-single.vue'
import InputUploadMultiple from './shared/form-fields/input/input-upload-multiple.vue'
import InputTextarea from './shared/form-fields/input/input-textarea.vue'
import InputCheckbox from './shared/form-fields/input/input-checkbox.vue'
import InputRadio from './shared/form-fields/input/input-radio.vue'
import InputDate from './shared/form-fields/input/input-date.vue'
import InputSelect from './shared/form-fields/input/input-select.vue'

import RecruitmentFormSuccessModal from './recruitment-form/modals/recruitment-form-success.vue'
import RecruitmentFormErrorModal from './recruitment-form/modals/recruitment-form-error.vue'
import ConfirmSubmissionModal from './recruitment-form/modals/confirm-submission.vue'

  export default {
    name: "RecruitmentForm",
    mixins: [SceneMixin, ModalMixin],
    data() {
      return {
        loadingApplication: false,
        positionId: null,
        applicationForm: null,
        applicationSent: false,
        formIsValid: false,
        recruitmentFormInput: null,
        translations: {
          send: {en: "Continue", fr: "Continuer"},
          back: {en: "Back to the home page", fr: "Retour à l'accueil"},
        },
      }
    },
    async created() {
      await this.fetchInitialData()
    },
    computed: {
      ...mapGetters("locales", ["currentLocale"]),
      ...mapGetters("positions", ["allPositions", "positionFormsById"]),
      ...mapGetters("recruitmentInfo", ["recruitmentInfo", "pageCopyright", "positionLabel"]),
      dataIsLoaded() {
        return (this.recruitmentInfo && this.positionLabel && this.allPositions.length)
      },
      recruitmentFormFields() {
        // excludes positions to avoid repetition
        return omitBy(this.applicationForm.form, (field) => field.id === "position_id")
      },
    },
    methods: {
      ...mapActions("positions", ["getAllPositions", "getPositionForm"]),
      ...mapActions("recruitmentInfo", ["getRecruitmentInfo"]),
      ...mapActions("application", ["sendApplication"]),
      async fetchInitialData() {
        try {
          await this.getRecruitmentInfo()
          await this.getAllPositions()
        } catch (err) {
          this.openModal("recruitment-form-error")
        }
      },
      async fetchAllData() {
        await this.fetchInitialData()
        if (this.dataIsLoaded) {
          await this.generatePositionForm()
        }
      },
      calculateFormIsValid() {
        const fieldsValid = this.$refs.field.every((field) => field.isValid)
        this.formIsValid = this.positionId && fieldsValid
      },
      async generatePositionForm() {
        if (!this.positionId) {
          this.applicationForm = null
        } else {
          this.loadingApplication = true
          await this.getPositionForm(this.positionId)
          this.applicationForm = this.positionFormsById[this.positionId]
          this.loadingApplication = false
        }
      },
      showConfirmationModal() {
        if (!this.formIsValid || this.loading) return
        const positions = map(this.allPositions, (p) => ({id: p.id, label: p.title }))
        this.recruitmentFormInput = [
            {
              value: this.positionId, inputName: "input_select_position_id",
              fieldType: "select", label: "Position", fieldId: "position_id",
              options: {choices: positions}
            },
            ...this.$refs.field
          ]
        this.openModal("confirm-submission")
      },
      async submitApplication() {
        if (!this.formIsValid || this.loading) return
        this.closeModal()
        this.loading = true
        try {
          await this.sendApplication([...this.$refs.field,
            {value: this.positionId, inputName: "input_select_position_id"}])
            this.applicationSent = true
          this.openModal("recruitment-form-success")
        } catch(err) {
          this.openModal("recruitment-form-error")
        }
        this.applicationForm = null
        this.loading = false
      },
    },
    components: {
      LocaleSwitcher,
      InputText,
      InputUploadSingle,
      InputUploadMultiple,
      InputCheckbox,
      InputRadio,
      InputDate,
      InputSelect,
      InputTextarea,
      RecruitmentFormSuccessModal,
      RecruitmentFormErrorModal,
      ConfirmSubmissionModal
    },
  }
  </script>

  <template lang="pug">
    div.recruitment-form-container
      div.recruitment-form(v-if="loaded")
        loading-screen(v-if="loading")

        recruitment-form-success-modal(v-if="modalVisible && modalName === 'recruitment-form-success'", @close="closeModal")
        recruitment-form-error-modal(v-if="modalVisible && modalName === 'recruitment-form-error'", @close="closeModal")
        confirm-submission-modal(v-if="modalVisible && modalName === 'confirm-submission'", @close="closeModal", :recruitment-form-input="recruitmentFormInput", @confirm="submitApplication")

        nav
          a.logo-link(href="http://cerc-datascience.polymtl.ca/", target="_blank")
            img.logo(src="../static/images/DSDMlogo_Full.png")
          locale-switcher.locale-switcher(@switch="fetchAllData")

        div.application-form-container(v-if="dataIsLoaded")

          div.application-information
            div(v-html="recruitmentInfo")

          div.application-form
            form(enctype="multipart/form-data")

            div(v-if="!applicationSent")
              div.position-select.mandatory
                div.form-row
                  label.label {{positionLabel}}
                  select(v-model="positionId", @change="generatePositionForm")
                    option(:value="null") --
                    option(v-for="position in allPositions", :value="position.id") {{position.title}}

              transition(name="ease")
                div.position-fields(v-if="applicationForm && !loadingApplication")
                  component.form-row(
                    ref="field", v-for="field in recruitmentFormFields",
                    :is="field.type", :label="field.label", :options="field.options",
                    :field-id="field.id", :field-type="field.type", :class="{'mandatory': !field.options.optional}",
                    @input="calculateFormIsValid"
                  )
                  div.form-row
                    button.submit(type="button", @click="showConfirmationModal", :disabled="!formIsValid", :class="{'--disabled': !formIsValid}") {{translations["send"][currentLocale]}}

            div(v-else)
              p.back-link
                a(href="http://cerc-datascience.polymtl.ca/") {{translations["back"][currentLocale]}}

      footer
        div.copyright {{pageCopyright}}

  </template>

  <style>

  @import "../init/variables.css";

.recruitment-form-container {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;

  & footer {
    margin: 0;
    margin-top: 3em;
    padding: 15px 0px;
    background-color: black;
    color: #828282;
    width: 100%;
    & .copyright {
      font-size: .9em;
      margin: 0 15px;
      text-align: center;
    }
  }
}

.recruitment-form {

  max-width: 960px;
  margin: auto;

  & nav {
    z-index: 2;
    position: fixed;
    top: 0;
    right: 0;
    left: 0;
    width: 100%;
    height: var(--navHeight)em;
    background-color: black;
    padding: 10px;
    display: flex;
    justify-content: space-between;
    & .logo-link {
      display: inline-block;
    }

    & .logo {
      height: calc(var(--navHeight) + 5)em;
      margin: -3em;
    }
    & .locale-switcher {
      float: right;
      margin: 1.5em;
    }
  }

  & .application-form-container {
    margin-top: calc(var(--navHeight) + 2)em;
  }

  & .application-form {
    transition: transform .5s;
    width: 90%;
    margin: auto;
    padding-top: 20px;

    & .label {
      display: inline-block;
      width: 30%;
      margin-right: 10px;
      vertical-align: top;
      text-align: right;
    }
    & .position-select {
      padding-bottom: 20px;
    }
    & .position-fields {
      & .form-row {
        margin: 10px auto;
      }
    }
  }
}

.ease-enter-active, .ease-leave-active {
  transition: all .5s ease-in;
}

.ease-enter, .ease-leave-to {
  opacity: 0;
  transform: translateY(100px);
}

.back-link {
  text-align: center;
}

@media screen and (max-width: 400px) {

  .recruitment-form .application-form  {
    & .position-select, & .position-fields {
      & .form-row {
        display: flex;
        flex-direction: column;
        margin: 2em auto;
        & label {
          width: 100%;
          text-align: left;
          margin: auto;
        }
        & input, & textarea, & select, & button.submit, & .input, & .file-list {
          width: 100%;
        }
      }
    }
  }




  .recruitment-form nav {
    display: flex;
    align-items: center;
    & .logo-link {
      text-align: center;
      & .logo {
        height: calc(var(--navHeight) + 2)em;
        margin: -2.5em;
        margin-left: -3.5em;
      }
    }
    & .locale-switcher {
      margin: 0;
      & button {
        padding: .9em;
      }
    }
  }
}

  </style>
