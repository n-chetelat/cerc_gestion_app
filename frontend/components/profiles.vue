  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { keyBy, pick } from "lodash-es"

import { mapGetters, mapActions } from "vuex"

import Field from "components/profiles/field.vue"
import StaticField from "components/profiles/static-field.vue"
import ProfilesSidebar from "components/profiles/profiles-sidebar.vue"
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
        const dynamicFields = this.fields.map(f => f.id)
        const staticFields = Object.keys(this.staticFields)
        this.selectedFields = [...staticFields, ...dynamicFields]
      } catch (err) {
        this.openModal("server-error", {})
      }
    },
    data() {
      return {
        cellHeight: 62,
        sidebarOpen: false,
        selectedFields: [],
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
      filteredStaticFields() {
        return pick(this.staticFields, this.selectedFields)
      },
      filteredFields() {
        return this.fields.filter(f => this.selectedFields.includes(f.id))
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
      toggleSidebarOpen(isOpen) {
        this.sidebarOpen = isOpen
      },
      filterFields(filteredFieldIds) {
        this.selectedFields = [...filteredFieldIds]
      }
    },
    components: {
      Field,
      StaticField,
      ProfilesSidebar,
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
        div.table.names-table
          table
            thead
              tr
                th(v-for="(label, key) in nameFields") {{label}}
            tbody
              tr(v-for="profile in profiles")
                td(v-for="(label, key) in nameFields")
                  static-field(:profile="profile", :field-name="key", @error="openModalByName('server-error')", @valid="signalFieldValidity")


        div.table.dynamic-table.profiles-table
          table
            thead
              tr
                th(v-for="(label, key) in filteredStaticFields") {{label}}
                th(v-for="field in filteredFields") {{field.label}}
            tbody
              tr(v-for="profile in profiles")
                td(v-for="(label, key) in filteredStaticFields")
                  static-field(:profile="profile", :field-name="key", @error="openModalByName('server-error')", @valid="signalFieldValidity")
                td(v-for="field in filteredFields")
                  field(:profile="profile", :field="field", @error="openModalByName('server-error')", @valid="signalFieldValidity")

      profiles-sidebar.sidebar(v-if="selectedFields && selectedFields.length", @toggle="toggleSidebarOpen",
        :static-fields="staticFields", :dynamic-fields="fields",
        :class="{'--open': sidebarOpen}", @modal="openModalByName", @filter="filterFields")

  </template>

  <style>

  @import "../init/variables.css";

  .profiles {
    display: flex;
    flex-wrap: nowrap;
    height: 100%;

    & .sidebar {
      position: fixed;
      right: calc(var(--profilesSidebarOffset)*-1)em;
      height: 100%;
      width: var(--profilesSidebarWidth)em;
      transition: transform .5s;

      &.--open {
        transform: translateX(calc(var(--profilesSidebarOffset)*-1)em);
      }
    }

    & .profiles-table {
      transform: translate(calc(var(--nameCellWidth)*2+2)em, 0);
    }

  }

  </style>
