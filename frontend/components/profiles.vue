  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { keyBy } from "lodash-es"

import { mapGetters, mapActions } from "vuex"

import Field from "components/profiles/field.vue"
import StaticField from "components/profiles/static-field.vue"
import ServerErrorModal from "./boards/modals/server-error.vue"

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
      staticFields() {
        return {
          name: "Name",
          lastname: "Lastname",
          position_id: "Position",
          email: "Email",
          starting_date: "Starting Date"
        }
      },
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
      },
      openModalByName(modalName, data={}) {
        this.openModal(modalName)
      },
      signalFieldValidity(event, value) {
        const cell = event.target.closest("td")
        if (!cell) return
        if (value) {
          cell.classList.remove("--invalid")
        } else {
          cell.classList.add("--invalid")
        }
      }
    },
    components: {
      Field,
      StaticField,
      ServerErrorModal
    }
  }
  </script>

  <template lang="pug">
    div.profiles
      server-error-modal(@close="closeModal", v-if="modalVisible && modalName === 'server-error'")
      table.profiles-table
        thead
          tr
            //- th.static(v-for="(label, key) in staticFields") {{label}}
            th(v-for="field in fields") {{field.label}}
        tbody
          tr(v-for="profile in profiles")
            //- td.static(v-for="(label, key) in staticFields")
            //-   static-field(:profile="profile", :field-name="key", @error="openModalByName('server-error')", @valid="signalFieldValidity")
            td(v-for="field in fields")
              field(:profile="profile", :field="field", @error="openModalByName('server-error')", @valid="signalFieldValidity")



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
        border: 1px solid var(--themeColor);
      }
    }

    & td {
      &.--invalid {
        background-color: var(--errorColor);
      }
    }

    & .profiles-table {
      margin: 10px;
    }

  }

  </style>
