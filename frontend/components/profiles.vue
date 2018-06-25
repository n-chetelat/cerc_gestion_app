  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { keyBy } from "lodash-es"

import { mapGetters, mapActions } from "vuex"

import Field from "components/profiles/field.vue"
import StaticField from "components/profiles/static-field.vue"

  export default {
    name: "Profiles",
    mixins: [SceneMixin, ModalMixin],
    async created() {
      try {
        await this.fetchProfileFields()
        await this.fetchProfiles()
        await Promise.all([
          this.getAllPositions(),
          this.fetchSemesters(),
          this.fetchMonths(),
        ])
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
      ...mapActions("positions", ["getAllPositions"]),
      ...mapActions("dates", ["fetchSemesters", "fetchMonths"]),
      openModalByName(modalName, data) {
        this.openModal(modalName)
      },
      getProfileStaticField(profile, attr) {
        return {value: profile[attr], form: 'text'}
      }
    },
    components: {
      Field,
      StaticField
    }
  }
  </script>

  <template lang="pug">
    div.profiles
      table.profiles-table
        thead
          tr
            th.static Name
            th.static Lastname
            th.static Position
            th.static Email
            th.static Starting Date
            th(v-for="field in fields") {{field.label}}
        tbody
          tr(v-for="profile in profiles")
            td.static
              static-field(:profile="profile", :field-name="'name'")
            td.static
              static-field(:profile="profile", :field-name="'lastname'")
            td.static
              static-field(:profile="profile", :field-name="'position_id'")
            td.static
              static-field(:profile="profile", :field-name="'email'")
            td.static
              static-field(:profile="profile", :field-name="'starting_date'")
            td(v-for="field in fields")
              field(:profile="profile", :field="field")



  </template>

  <style>

  @import "../init/variables.css";

  :root {
    --cellWidth: 130;
  }

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

      &.static {
        border: 2px solid var(--themeColor);
      }
    }

    & .profiles-table {
      margin: 10px;
    }

  }

  </style>
