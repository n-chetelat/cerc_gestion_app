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
        application: {
          positionId: null
        },
        applicationForm: null,
        generatingForm: false,
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
      async generatePositionForm() {
        if (!this.application.positionId) {
          this.applicationForm = null
        } else {
          this.generatingForm = true
          await this.getPositionForm(this.application.positionId).then(() => {
          })
          const form = this.positionFormsById[this.application.positionId]
          this.applicationForm = form
          this.generatingForm = false
        }
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
      InputTextarea
    }
  }
  </script>

  <template lang="pug">
    div.recruitment-form(v-if="loaded")
      nav
        locale-switcher.locale-switcher
      div.information(v-html="recruitmentInfo")
      div.application-form
        form(enctype="multipart/form-data")
          div.form-row.position-select
            label.label Position
            select(v-model="application.positionId", @change="generatePositionForm")
              option(:value="null") --
              option(v-for="position in allPositions", :value="position.id") {{position.title}}
          div.position-fields(v-if="applicationForm && !generatingForm")
            component.form-row(v-for="field in applicationForm.form", :is="field.type", :label="field.label", :options="field.options", :field-id="field.id")
  </template>

  <style>

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

  </style>
