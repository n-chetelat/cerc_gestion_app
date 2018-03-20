<script>
import { mapGetters, mapActions } from 'vuex'

import SceneMixin from 'mixins/scene-mixin.js'

import InputText from './recruitment-form/input-text.vue'

  export default {
    name: "RecruitmentForm",
    mixins: [SceneMixin],
    data() {
      return {
        application: {
          positionId: null
        },
        positions: [],
        applicationForm: null,
        generatingForm: false,
      }
    },
    async created() {
      await this.getAllPositions()
      this.positions = this.allPositions
    },
    computed: {
      ...mapGetters("positions", ["allPositions", "positionFormsById"]),
    },
    methods: {
      ...mapActions("positions", ["getAllPositions", "getPositionForm"]),
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
      InputText
    }
  }
  </script>

  <template lang="pug">
    div.recruitment-form(v-if="loaded")
      div.application-form
        form
          div.form-row.position-select
            label.label Which position are you applying for?
            select(v-model="application.positionId", @change="generatePositionForm")
              option(:value="null") Select a position
              option(v-for="position in positions", :value="position.id") {{position.title}}
          div.position-fields(v-if="applicationForm && !generatingForm")
            component.form-row(v-for="field in applicationForm.form", :is="field.type", :label="field.label", :options="field.options")
  </template>

  <style>
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
      vertical-align: top;
      text-align: right;
    }

    .application-form input[type="text"] {
      width: 20em;
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

  </style>
