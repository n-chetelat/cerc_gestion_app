<script>
import { mapGetters, mapActions } from 'vuex'

import SceneMixin from 'mixins/scene-mixin.js'
import ModalMixin from 'mixins/modal-mixin.js'

import LocaleSwitcher from './shared/locale-switcher.vue'

import InputText from './recruitment-form/input-text.vue'
import InputUploadSingle from './recruitment-form/input-upload-single.vue'
import InputUploadMultiple from './recruitment-form/input-upload-multiple.vue'
import InputTextarea from './recruitment-form/input-textarea.vue'
import InputCheckbox from './recruitment-form/input-checkbox.vue'
import InputRadio from './recruitment-form/input-radio.vue'
import InputDate from './recruitment-form/input-date.vue'
import InputSelect from './recruitment-form/input-select.vue'

import RecruitmentFormSuccessModal from './recruitment-form/modals/recruitment-form-success.vue'
import RecruitmentFormErrorModal from './recruitment-form/modals/recruitment-form-error.vue'

  export default {
    name: "RecruitmentForm",
    mixins: [SceneMixin, ModalMixin],
    data() {
      return {
        positionId: null,
        applicationForm: null,
        applicationSent: false,
        formIsValid: false,
        translations: {
          send: {en: "Send", fr: "Envoyer"},
          position: {en: "Select the type of application you wish to send",
            fr: "Sélectionnez le type d'application que vous désirez envoyer"
          },
          back: {en: "Back to the home page",
            fr: "Retour à l'accueil"
          }
        }
      }
    },
    async created() {
      await this.fetchInitialData()
    },
    computed: {
      ...mapGetters("locales", ["currentLocale"]),
      ...mapGetters("positions", ["allPositions", "positionFormsById"]),
      ...mapGetters("recruitmentInfo", ["recruitmentInfo"]),
    },
    methods: {
      ...mapActions("positions", ["getAllPositions", "getPositionForm"]),
      ...mapActions("recruitmentInfo", ["getRecruitmentInfo"]),
      ...mapActions("application", ["sendApplication"]),
      async fetchInitialData() {
        await this.getRecruitmentInfo()
        await this.getAllPositions()
      },
      async fetchAllData() {
        await this.fetchInitialData()
        await this.generatePositionForm()
      },
      calculateFormIsValid() {
        const fieldsValid = this.$refs.field.every((field) => field.isValid)
        this.formIsValid = this.positionId && fieldsValid
      },
      async generatePositionForm() {
        if (!this.positionId) {
          this.applicationForm = null
        } else {
          this.loading = true
          await this.getPositionForm(this.positionId)
          this.applicationForm = this.positionFormsById[this.positionId]
          this.loading = false
        }
      },
      async submitApplication() {
        if (!!this.formIsValid || this.loading) return
        this.loading = true
        try {
          await this.sendApplication([...this.$refs.field,
            {value: this.positionId, inputName: "position_id"}])
            this.applicationSent = true
          this.openModal("recruitment-form-success")
        } catch(error) {
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
      RecruitmentFormErrorModal
    },
  }
  </script>

  <template lang="pug">
    div.recruitment-form(v-if="loaded")
      loading-screen(v-if="loading")

      recruitment-form-success-modal(v-if="modalVisible && modalName === 'recruitment-form-success'", @close="closeModal")
      recruitment-form-error-modal(v-if="modalVisible && modalName === 'recruitment-form-error'", @close="closeModal")

      nav
        locale-switcher.locale-switcher(@switch="fetchAllData")

      div.application-information(v-html="recruitmentInfo")

      div.application-form
        form(enctype="multipart/form-data")

        div(v-if="!applicationSent")
          div.position-select.mandatory
            label.label {{translations["position"][currentLocale]}}
            select(v-model="positionId", @change="generatePositionForm")
              option(:value="null") --
              option(v-for="position in allPositions", :value="position.id") {{position.title}}

          div.position-fields(v-if="applicationForm && !loading")
            component.form-row(
              ref="field", v-for="field in applicationForm.form",
              :is="field.type", :label="field.label", :options="field.options",
              :field-id="field.id", :field-type="field.type", :class="{'mandatory': !field.options.optional}",
              @input="calculateFormIsValid"
            )
            div.form-row
              button.submit(type="button", @click="submitApplication", :disabled="!formIsValid", :class="{'--disabled': !formIsValid}") {{translations["send"][currentLocale]}}

        div(v-else)
          p.back-link
            a(href="http://cerc-datascience.polymtl.ca/") {{translations["back"][currentLocale]}}

  </template>

  <style>

  .recruitment-form {
    & nav {
      width: 100%;
      height: 5em;
      & .locale-switcher {
        margin: 1em auto;
        float: right;
      }
    }

    & .application-form {
      width: 90%;
      margin: auto;
      border-top: 2px solid black;
      padding-top: 20px;
      & .label {
        display: inline-block;
        width: 30%;
        margin-right: 10px;
        vertical-align: top;
        text-align: right;
      }
      & .choice-group {
        display: inline-block;
        max-width: 20em;
        border: none;
        & label {
          margin: 5px 5px 0 15px;
          display: inline-block;
        }
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

  .mandatory .label:after {
    content: "*";
    color: red;
    margin-left: 2px;
  }

  .file-list {
    list-style: none;
    padding-left: 0;
    max-width: 20em;
    margin: auto;
    & .file-line {
      position: relative;
      display: inline-block;
      height: 2em;
      line-height: 2em;
      margin-top: 3px;
      & span {
        margin-left: 2em;
      }
    }
    & .remove {
      position: absolute;
      left: 0;
      top: 0;
    }
  }

  .back-link {
    text-align: center;
  }

  </style>
