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
        generatingForm: false,
        sending: false,
        applicationSent: false,
        savedApplication: null,
      }
    },
    async created() {
      await this.getRecruitmentInfo()
      await this.getAllPositions()
    },
    computed: {
      ...mapGetters("positions", ["allPositions", "positionFormsById"]),
      ...mapGetters("recruitmentInfo", ["recruitmentInfo"]),
    },
    methods: {
      ...mapActions("positions", ["getAllPositions", "getPositionForm"]),
      ...mapActions("recruitmentInfo", ["getRecruitmentInfo"]),
      ...mapActions("application", ["sendApplication"]),
      async generatePositionForm() {
        if (!this.positionId) {
          this.applicationForm = null
        } else {
          this.generatingForm = true
          await this.getPositionForm(this.positionId).then(() => {
          })
          const form = this.positionFormsById[this.positionId]
          this.applicationForm = form
          this.generatingForm = false
        }
      },
      async submitApplication() {
        this.sending = true
        this.savedApplication = await this.sendApplication([...this.$refs.field,
          {value: this.positionId, inputName: "position_id"}])
        this.applicationForm = null
        this.applicationSent = true
        this.sending = false
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
      //- div.loading-overlay(v-if="sending")
      nav
        locale-switcher.locale-switcher
      div.information(v-html="recruitmentInfo")
      div.application-form
        form(enctype="multipart/form-data")
          div.form-row.position-select(v-if="!applicationSent")
            label.label Position
            select(v-model="positionId", @change="generatePositionForm")
              option(:value="null") --
              option(v-for="position in allPositions", :value="position.id") {{position.title}}
          div.position-fields(v-if="applicationForm && !generatingForm")
            component.form-row(ref="field", v-for="field in applicationForm.form", :is="field.type", :label="field.label", :options="field.options", :field-id="field.id", :field-type="field.type")
            div.form-row
              button.submit(type="button", @click="submitApplication") Send
          div.info-message(v-if="applicationSent")
            p Your application has been sent.
            p You will hear from us soon.
  </template>

  <style>

  .loading-overlay {
    width: 100%;
    height: 1000px;
    position: absolute;
    top: 0;
    /* background-color: rgba(0, 0, 0, .5); */
    left: 0;
  }

    .recruitment-form nav {
      width: 100%;
      height: 5em;
    }

    .recruitment-form nav .locale-switcher {
      margin: 1em auto;
      float: right;
    }

    .application-form {
      width: 90%;
      margin: auto;
      border-top: 2px solid black;
      padding-top: 20px;
    }

    .position-fields .form-row {
      margin: 10px auto;
    }

    .application-form .label {
      display: inline-block;
      width: 30%;
      margin-right: 10px;
      vertical-align: middle;
      text-align: right;
    }

    .position-select {
      padding-bottom: 20px;
    }

    .position-select select {
      display: inline-block;
      padding: .7em;
      width: 20em;
      background-color: white;
    }

    .application-form .choice-group {
      display: inline-block;
      max-width: 20em;
      border: none;
    }

    .application-form .choice-group label {
      margin: 5px 5px 0 15px;
      display: inline-block;
    }

    .file-list {
      list-style: none;
      max-width: 20em;
      margin: auto;
    }

    .file-list li {
      margin-top: 3px;
    }

    button.remove {
      margin: auto 15px;
      width: 1.7em;
      height: 1.7em;
      padding: 2px;
    }

    .submit {
      width: 20em;
      margin: auto;
      display: block;
    }

    .info-message {
      text-align: center;
      width: 33%;
      margin: auto;
    }

  </style>
