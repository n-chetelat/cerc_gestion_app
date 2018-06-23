  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { keyBy } from "lodash-es"

import { mapGetters, mapActions } from "vuex"

import Field from "components/profiles/field.vue"

  export default {
    name: "Profiles",
    mixins: [SceneMixin, ModalMixin],
    async created() {
      try {
        await this.fetchProfileFields()
        await this.fetchProfiles()
      } catch (err) {
        this.openModal("server-error", {})
      }
    },
    data() {
      return {
      }
    },
    computed: {
      ...mapGetters("profiles", ["profiles", "fields"]),
    },
    methods: {
      ...mapActions("profiles", ["fetchProfiles", "fetchProfileFields"]),
      openModalByName(modalName, data) {
        this.openModal(modalName)
      },
    },
    components: {
      Field
    }
  }
  </script>

  <template lang="pug">
    div.profiles
      table.profiles-table
        thead
          tr
            th Name
            th Lastname
            th Position
            th Email
            th Starting Date
            th(v-for="field in fields") {{field.label}}
        tbody
          tr(v-for="profile in profiles")
            td {{profile.name}}
            td {{profile.lastname}}
            td {{profile.position}}
            td {{profile.email}}
            td {{profile.starting_date}}
            td(v-for="field in fields")
              field(:profile="profile", :field="field")



  </template>

  <style>

  .profiles {
    display: flex;
    flex-wrap: nowrap;
    overflow-x: auto;
    height: 100%;

    & table, th, td {
      border: 1px solid;
      border-collapse: collapse;
    }

    & th, td {
      min-width: 100px;
      text-align: center;
      vertical-align: baseline;
      padding: 10px;
    }

    & .profiles-table {
      margin: 10px;
    }
  }

  </style>
