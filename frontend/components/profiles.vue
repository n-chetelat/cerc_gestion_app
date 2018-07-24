  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"
import FilterMixin from "mixins/filter-mixin.js"

import { keyBy, pick, filter } from "lodash-es"

import { mapGetters, mapActions } from "vuex"

import AdminNav from "components/shared/admin-nav.vue"
import NamesTable from "components/profiles/names-table.vue"
import ProfilesTable from "components/profiles/profiles-table.vue"
import ProfilesSidebar from "components/profiles/profiles-sidebar.vue"

import NewProfileModal from "components/profiles/modals/new-profile.vue"
import ServerErrorModal from "./boards/modals/server-error.vue"

  export default {
    name: "Profiles",
    mixins: [SceneMixin, ModalMixin, FilterMixin],
    async created() {
      try {
        await this.fetchProfileFields()
        await this.fetchProfiles()
        await Promise.all([
          this.getAllPositions(),
          this.fetchSemesters({extended: true}),
          this.fetchMonths({extended: true}),
        ])
        if (localStorage.getItem("profile-fields")) {
          this.selectedFields = JSON.parse(localStorage.getItem("profile-fields"))
        } else {
          const dynamicFields = this.fields.map(f => f.id)
          const staticFields = Object.keys(this.staticFields)
          this.selectedFields = [...staticFields, ...dynamicFields]
        }
      } catch (err) {
        this.openModal("server-error", {})
      }
    },
    data() {
      return {
        sidebarOpen: false,
        selectedFields: [],
      }
    },
    computed: {
      ...mapGetters("profiles", [, "profiles", "fields"]),
      staticFields() {
        return {
          position_id: "Position",
          email: "Email",
          starting_date: "Starting Date"
        }
      },
      filteredProfiles() {
        if (!this.profiles) return []
        if (!this.filteredProfileIds.length) return this.profiles
        return filter(this.profiles, (p) => this.filteredProfileIds.includes(p.id))
      },
      filteredStaticFields() {
        return pick(this.staticFields, this.selectedFields)
      },
      filteredFields() {
        return this.fields.filter(f => this.selectedFields.includes(f.id))
      },
      profilesTableMinHeight() {
        const cellHeight = 55
        return (this.profiles.length + 2) * cellHeight // Add the equivalent of 2 more cells for headers/padding.
      }
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
      },
    },
    components: {
      AdminNav,
      NamesTable,
      ProfilesTable,
      ProfilesSidebar,
      NewProfileModal,
      ServerErrorModal
    },
    watch: {
      selectedFields: function(val, oldVal) {
        const fieldsToRemember = JSON.stringify(val)
        localStorage.setItem("profile-fields", fieldsToRemember)
      }
    }
  }
  </script>

  <template lang="pug">
    div.profiles
      server-error-modal(@close="closeModal", v-if="modalVisible && modalName === 'server-error'")
      new-profile-modal(@close="closeModal", v-if="modalVisible && modalName === 'new-profile'", @error="openModalByName('server-error')")

      admin-nav.admin-nav(@filter="filterProfiles")

      div.tables
        names-table(:displayed-profiles="filteredProfiles",
          @filter="filterProfiles",
          @selection="selectProfiles",
          @error="openModalByName('server-error')", @valid="signalFieldValidity")


        profiles-table.dynamic-table(
          :displayed-profiles="filteredProfiles",
          :selected-profile-ids="selectedProfileIds",
          :static-fields="filteredStaticFields",
          :fields="filteredFields",

          @error="openModalByName('server-error')", @valid="signalFieldValidity",
          :style="{minHeight: `${profilesTableMinHeight}px`}")

      profiles-sidebar.sidebar(@toggle="toggleSidebarOpen",
        :static-fields="staticFields", :dynamic-fields="fields",
        :class="{'--open': sidebarOpen}", @modal="openModalByName", @filter="filterFields")

  </template>

  <style>

  @import "../init/variables.css";

  :root {
    --profilesTableOffset: calc(var(--cellWidth)*(2+var(--selectionBoxRatio)));
  }

  .profiles {
    display: flex;
    flex-direction: column;
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

    & .admin-nav, & .tables {
      width: 96%;
    }

    & .profiles-table {
      position: absolute;
      left: var(--profilesTableOffset)em;
      width: calc(100% - var(--profilesTableOffset)em);
    }

  }

  </style>
