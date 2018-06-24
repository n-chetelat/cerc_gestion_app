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
      getProfileStaticField(profile, attr) {
        return {value: profile[attr], form: 'text'}
      }
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
            td
              field(:profile="profile", :field="getProfileStaticField(profile, 'name')")
            td
              field(:profile="profile", :field="getProfileStaticField(profile, 'lastname')")
            td
              field(:profile="profile", :field="getProfileStaticField(profile, 'position')")
            td
              field(:profile="profile", :field="getProfileStaticField(profile, 'email')")
            td
              field(:profile="profile", :field="getProfileStaticField(profile, 'starting_date')")
            td(v-for="field in fields")
              field(:profile="profile", :field="field")



  </template>

  <style>

  @import "../init/variables.css";

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
      padding: 10px;
      font-family: var(--textFamily);
    }

    & .profiles-table {
      margin: 10px;
    }
  }

  </style>
