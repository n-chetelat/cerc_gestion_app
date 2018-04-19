<script>
import { mapGetters, mapActions } from 'vuex'

import SceneMixin from 'mixins/scene-mixin.js'
import ModalMixin from 'mixins/modal-mixin.js'

import LocaleSwitcher from './shared/locale-switcher.vue'

import InputText from './recruitment-form/form-fields/input-text.vue'
import InputUploadSingle from './recruitment-form/form-fields/input-upload-single.vue'
import InputUploadMultiple from './recruitment-form/form-fields/input-upload-multiple.vue'
import InputTextarea from './recruitment-form/form-fields/input-textarea.vue'
import InputCheckbox from './recruitment-form/form-fields/input-checkbox.vue'
import InputRadio from './recruitment-form/form-fields/input-radio.vue'
import InputDate from './recruitment-form/form-fields/input-date.vue'
import InputSelect from './recruitment-form/form-fields/input-select.vue'

import RecruitmentFormSuccessModal from './recruitment-form/modals/recruitment-form-success.vue'
import RecruitmentFormErrorModal from './recruitment-form/modals/recruitment-form-error.vue'

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
          this.loadingApplication = true
          await this.getPositionForm(this.positionId)
          this.applicationForm = this.positionFormsById[this.positionId]
          this.loadingApplication = false
        }
      },
      async submitApplication() {
        if (!this.formIsValid || this.loading) return
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
        a.logo-link(href="http://cerc-datascience.polymtl.ca/", target="_blank")
          img.logo(src="../static/images/DSDMlogo_Full.png")
        locale-switcher.locale-switcher(@switch="fetchAllData")

      div.application-form-container

        div.application-information
          div(v-html="recruitmentInfo")

        div.application-form
          form(enctype="multipart/form-data")

          div(v-if="!applicationSent")
            div.position-select.mandatory
              label.label {{translations["position"][currentLocale]}}
              select(v-model="positionId", @change="generatePositionForm")
                option(:value="null") --
                option(v-for="position in allPositions", :value="position.id") {{position.title}}

            transition(name="ease")
              div.position-fields(v-if="applicationForm && !loadingApplication")
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

  :root {
    --navHeight: 8;
  }

.recruitment-form {

  & nav {
    position: fixed;
    top: 0;
    right: 0;
    left: 0;
    width: 100%;
    height: var(--navHeight)em;
    background-color: black;
    padding: 10px;
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

  </style>
