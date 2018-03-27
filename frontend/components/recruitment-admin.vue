  <script>
import SceneMixin from "mixins/scene-mixin.js"

import { mapGetters, mapActions } from "vuex"

import PersonInfoModal from "./shared/modals/person-info.vue"

  export default {
    name: "RecruitmentAdmin",
    mixins: [SceneMixin],
    async created() {
      await this.fetchPhases()
    },
    data() {
      return {
        currentPersonId: null
      }
    },
    computed: {
      ...mapGetters("phases", ["allPhases"]),
    },
    methods: {
      ...mapActions("phases", ["fetchPhases"]),
      ...mapActions("persons", ["fetchPerson"]),
      async showPersonInfo(person) {
        this.currentPersonId = person.id
        this.openModal('person-info')
      },
      hidePersonInfo() {
        this.closeModal()
        this.currentPersonId = null
      }
    },
    components: {
      PersonInfoModal
    }
  }
  </script>

  <template lang="pug">
    div.recruitment-admin(v-if="loaded")
      person-info-modal(@close="hidePersonInfo", v-if="modalVisible && modalName === 'person-info'", :person-id="currentPersonId")

      div.tag-column(v-for="phase in allPhases")
        h2 {{phase.title}}
        p You have {{phase.persons.length}} person(s) in this section.
        div.applicant-card(v-for="person in phase.persons")
          h3 {{person.full_name}}
          p {{person.email}}
          p Applying for: {{person.position}}
          p Starting on: {{person.starting_semester}}
          p Received on: {{person.applied_at}}
          button(type="button", @click="showPersonInfo(person)") More...
  </template>

  <style scoped>

    .recruitment-admin {

      & .tag-column {
        border: 3px solid black;
        width: 30%;
        height: 600px;
        overflow-y: auto;
        overflow-x: hidden;
        float: left;
      }

      & .applicant-card {
        padding: 10px;
        margin: 5px;
        background-color: yellow;
      }

    }

  </style>
