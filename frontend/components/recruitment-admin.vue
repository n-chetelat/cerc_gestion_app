  <script>
import SceneMixin from 'mixins/scene-mixin.js'

import { mapGetters, mapActions } from "vuex"

  export default {
    name: "RecruitmentAdmin",
    mixins: [SceneMixin],
    async created() {
      await this.fetchApplications()
    },
    computed: {
      ...mapGetters("application", ["getApplications"])
    },
    methods: {
      ...mapActions("application", ["fetchApplications"])
    },
  }
  </script>

  <template lang="pug">
    div.recruitment-admin(v-if="loaded")
      div.tag-column
        h2 New applications
        p You have {{getApplications.length}} new application(s)
        div.applicant-card(v-for="application in getApplications")
          h3 {{application.name}}
          p {{application.email}}
          p Applying for: {{application.position}}
          p Starting on: {{application.starting_semester}}
          p Received on: {{application.created_at}}
  </template>

  <style scoped>

    .tag-column {
      border: 3px solid black;
      width: 30%;
      height: 600px;
      overflow-y: auto;
      overflow-x: hidden;
    }

    .applicant-card {
      padding: 10px;
      margin: 5px;
      background-color: yellow;
    }

  </style>
