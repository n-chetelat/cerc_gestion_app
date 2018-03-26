<script>
import { mapGetters, mapActions } from 'vuex'

import SceneMixin from 'mixins/scene-mixin.js'

import LocaleSwitcher from './shared/locale-switcher.vue'

import InputText from './recruitment-form/input-text.vue'
import InputUploadSingle from './recruitment-form/input-upload-single.vue'
import InputUploadMultiple from './recruitment-form/input-upload-multiple.vue'
import InputTextarea from './recruitment-form/input-textarea.vue'
import InputCheckbox from './recruitment-form/input-checkbox.vue'
import InputRadio from './recruitment-form/input-radio.vue'
import InputDate from './recruitment-form/input-date.vue'
import InputSelect from './recruitment-form/input-select.vue'

  export default {
    name: "RecruitmentForm",
    mixins: [SceneMixin],
    data() {
      return {
        positionId: null,
        applicationForm: null,
        applicationSent: false,
        translations: {
          send: {en: "Send", fr: "Envoyer"},
          position: {en: "Select the type of application you wish to send",
            fr: "Sélectionnez le type d'application que vous désirez envoyer"
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
        this.loading = true
        await this.sendApplication([...this.$refs.field,
          {value: this.positionId, inputName: "position_id"}])
        this.applicationForm = null
        this.applicationSent = true
        this.loading = false
      }
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
      InputTextarea
    }
  }
  </script>

  <template lang="pug">
    div.recruitment-form(v-if="loaded")

      nav
        locale-switcher.locale-switcher(@switch="fetchAllData")

      div.application-information(v-html="recruitmentInfo")

      div.application-form(v-if="!applicationSent")
        form(enctype="multipart/form-data")

          div.position-select
            label.label {{translations["position"][currentLocale]}}
            select(v-model="positionId", @change="generatePositionForm")
              option(:value="null") --
              option(v-for="position in allPositions", :value="position.id") {{position.title}}

          div.position-fields(v-if="applicationForm && !loading")
            component.form-row(ref="field", v-for="field in applicationForm.form", :is="field.type", :label="field.label", :options="field.options", :field-id="field.id", :field-type="field.type")
            div.form-row
              button.submit(type="button", @click="submitApplication") {{translations["send"][currentLocale]}}

      div.info-message(v-else)
          p Your application has been sent.
          p You will hear from us soon.
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
        vertical-align: middle;
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
        & select {
          display: inline-block;
          padding: .7em;
          width: 20em;
          background-color: white;
        }
      }
      & .position-fields {
        & .form-row {
          margin: 10px auto;
        }
      }
    }
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

  .info-message {
    text-align: center;
    width: 33%;
    margin: auto;
  }

  </style>
