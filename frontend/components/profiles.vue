  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { keyBy } from "lodash-es"

import { mapGetters, mapActions } from "vuex"

import Field from "components/profiles/field.vue"
import StaticField from "components/profiles/static-field.vue"
import NewProfileModal from "components/profiles/modals/new-profile.vue"
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
        sidebarOpen: false,
      }
    },
    computed: {
      ...mapGetters("profiles", ["profiles", "fields"]),
      nameFields() {
        return {
          name: "Name",
          lastname: "Lastname"
        }
      },
      staticFields() {
        return {
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
      },
    },
    components: {
      Field,
      StaticField,
      NewProfileModal,
      ServerErrorModal
    }
  }
  </script>

  <template lang="pug">
    div.profiles
      server-error-modal(@close="closeModal", v-if="modalVisible && modalName === 'server-error'")
      new-profile-modal(@close="closeModal", v-if="modalVisible && modalName === 'new-profile'", @error="openModalByName('server-error')")

      div.tables
        table.table.names-table
          thead
            tr
              th(v-for="(label, key) in nameFields") {{label}}
          tbody
            tr(v-for="profile in profiles")
              td(v-for="(label, key) in nameFields")
                static-field(:profile="profile", :field-name="key", @error="openModalByName('server-error')", @valid="signalFieldValidity")

        table.table.profiles-table
          thead
            tr
              th(v-for="(label, key) in staticFields") {{label}}
              th(v-for="field in fields") {{field.label}}
          tbody
            tr(v-for="profile in profiles")
              td(v-for="(label, key) in staticFields")
                static-field(:profile="profile", :field-name="key", @error="openModalByName('server-error')", @valid="signalFieldValidity")
              td(v-for="field in fields")
                field(:profile="profile", :field="field", @error="openModalByName('server-error')", @valid="signalFieldValidity")

        aside.sidebar(:class="{'--open': sidebarOpen}")
          div.menu-icons
            button.toggle-menu(@click="sidebarOpen = !sidebarOpen", :class="{'--open': sidebarOpen}")
          div.actions
            button(type="button", @click="openModalByName('new-profile')") New Profile
            div.visible-columns
              div.column-line
                input(type="checkbox")
                label Select all columns
              div.column-line
                input(type="checkbox")
                label Hide all columns
              hr
              div.column-line(v-for="field in fields")
                input(type="checkbox", :value="field.id")
                label {{field.label}}

  </template>

  <style>

  @import "../init/variables.css";

  :root {
    --nameCellWidth: 12;
    --sidebarOffset: 16;
    --menuSpace: 3;
    --sidebarWidth: calc(var(--sidebarOffset)+var(--menuSpace));
  }

  .profiles {
    display: flex;
    flex-wrap: nowrap;
    height: 100%;

    & .tables {
      width: 100%;
      display: flex;
      flex-wrap: nowrap;
      overflow-x: auto;
      height: 100%;
    }

    .sidebar {
      position: fixed;
      right: calc(var(--sidebarOffset)*-1)em;
      height: 100%;
      background-color: var(--themeColor);
      width: var(--sidebarWidth)em;
      transition: transform .5s;

      display: flex;

      &.--open {
        transform: translateX(calc(var(--sidebarOffset)*-1)em);
      }

      & .menu-icons {
        width: 3em;
        text-align: center;
      }

      & .actions {
        width: var(--sidebarOffset)em;
        display: flex;
        flex-direction: column;
        margin: 3em auto;
        padding: 1em;
      }

      & .visible-columns {
        background-color: white;
        padding: 1em;
        margin-top: 1em;
        & .column-line {
          display: flex;
          padding-bottom: 5px;
          & input {
            width: 15%;
          }
        }
      }

      & .toggle-menu {
        width: var(--menuSpace)em;
        height: 3em;
        background: url("../static/icons/menu.svg") center center no-repeat;
        margin: 0;
        padding: 0;
        &.--open {
          background: url("../static/icons/x-charcoal.svg") center center no-repeat;
        }
      }
    }

    & table, th, td {
      border: 1px solid;
      border-collapse: collapse;
    }

    & th, td {
      padding: 10px;
      font-family: var(--textFamily);
    }

    & td {
      &.--invalid {
        background-color: var(--errorColor);
      }
    }

    & .table {
      margin: 10px 0;
    }

    & .names-table {
      position: fixed;
      background-color: white;
      z-index: 4;

      & tr:first-of-type {
        & th {
          border-top: 1px solid black;
        }
      }

      & tr:last-of-type {
        & td {
          border-bottom: 1px solid black;
        }
      }

      & th, td {
        border: 1px solid white;
        background-color: color(var(--themeColor) tint(40%));
      }

      & td .cell-display {
        width: var(--nameCellWidth)em;
      }
    }

    & .profiles-table {
      transform: translate(calc(var(--nameCellWidth)*2+2)em, 0);
      margin-left: 10px;
    }

  }

  </style>
