  <script>
import SceneMixin from 'mixins/scene-mixin.js'

import { mapGetters, mapActions } from "vuex"

  export default {
    name: "RecruitmentAdmin",
    mixins: [SceneMixin],
    async created() {
      await this.fetchPhases()
    },
    computed: {
      ...mapGetters("phases", ["allPhases"]),
      // ...mapGetters("application", ["getApplications"])
    },
    methods: {
      ...mapActions("phases", ["fetchPhases"]),
      // ...mapActions("application", ["fetchApplications"])
    },
  }
  </script>

  <template lang="pug">
    div.recruitment-admin(v-if="loaded")
      div.tag-column(v-for="phase in allPhases")
        h2 {{phase.title}}
        p You have {{phase.persons.length}} person(s) in this section.
        div.applicant-card(v-for="person in phase.persons")
          h3 {{person.name}}
          p {{person.email}}
          p Applying for: {{person.position}}
          //- p Starting on: {{application.starting_semester}}
          //- p Received on: {{application.created_at}}
  </template>

  <style scoped>

    .tag-column {
      border: 3px solid black;
      width: 30%;
      height: 600px;
      overflow-y: auto;
      overflow-x: hidden;
      float: left;
    }

    .applicant-card {
      padding: 10px;
      margin: 5px;
      background-color: yellow;
    }

  </style>
