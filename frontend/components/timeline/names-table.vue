  <script>
  import { mapGetters } from "vuex"

  import { filter } from "lodash-es"

  import FilterMixin from "mixins/filter-mixin.js"

  import StaticField from "components/profiles/static-field.vue"

  export default {
    name: "NamesTable",
    mixins: [FilterMixin],
    props: {
      displayedProfiles: { required: true }
    },
    data() {
      return {
        filterAction: null,
        filterActions: [
          {id: "show_all", label: "Show all"},
          {id: "show_selected", label: "Show selected"},
          {id: "deselect_all", label: "Deselect all"},
        ],
        nonFilterActions: ["deselect_all", "show_all"]
      }
    },
    computed: {
      ...mapGetters("profiles", [, "profiles"]),
      ...mapGetters("positions", ["allPositionsById"]),
      nameFields() {
        return {
          name: "Name",
          lastname: "Lastname"
        }
      },
      selectedProfileIdMap() {
        const profileIdMap = {}
        this.selectedProfileIds.forEach((id) => {
          profileIdMap[id] = id
        })
        return profileIdMap
      },
      IsFiltering() {
        return !this.filterAction || this.nonFilterActions.includes(this.filterAction)
      },
    },
    methods: {
      emitFilterAction() {
        this.takeFilterAction()
        this.$emit("filter", this.filteredProfileIds, this.IsFiltering)
      },
      emitSelectedProfiles() {
        this.$emit("selection", this.selectedProfileIds)
      },
      emitModalByName(name, data) {
        this.$emit("modal", name, data)
      },
      takeFilterAction() {
        if (!this.filterAction) return
        if (this.filterAction === "show_all") {
          this.filterProfiles(this.profiles.map((p) => p.id))
        } else if (this.filterAction === "show_selected") {
          this.filterProfiles(this.selectedProfileIds)
        } else if (this.filterAction === "deselect_all") {
          this.selectProfiles([])
          this.emitSelectedProfiles()
        }
        this.filterAction = null
      }
    },
    components: {
      StaticField,
    },
  }
  </script>

  <template lang="pug">
    div.table.names-table

      div.table-head
        div.row
          div.cell.name-cell.selection-box
            select(v-model="filterAction", @change="emitFilterAction")
              option(:value="null") -- Actions --
              option(v-for="action in filterActions", :value="action.id") {{action.label}}
          div.cell.name-cell Name

      div.table-body
        div.row.placeholder-row
          div.cell.name-cell
        div.row(v-for="profile in displayedProfiles", :class="{'--selected': selectedProfileIdMap[profile.id]}")
          div.cell.name-cell.selection-box
            input(type="checkbox", :value="profile.id", v-model="selectedProfileIds", @change="emitSelectedProfiles")
          div.cell.name-cell.full-name(@click="emitModalByName('profile-milestones', { profile })")
            div {{profile.full_name}}
            div.person-position-label {{allPositionsById[profile.position_id].title}}


  </template>

  <style scoped>

  @import "../../init/variables.css";

  .names-table {
    & .cell {
      flex-direction: column;
    }

    & .full-name {
      cursor: pointer;
    }

    & .person-position-label {
      font-size: .8em;
    }

  }

  </style>
