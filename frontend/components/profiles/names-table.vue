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
          {id: "active_only", label: "Show active"},
          {id: "incoming_only", label: "Show incoming"},
          {id: "rejected_only", label: "Show rejected"},
          {id: "finished_only", label: "Show finished"},
          {id: "deselect_all", label: "Deselect all"},
        ],
        nonFilterActions: ["deselect_all", "show_all"]
      }
    },
    computed: {
      ...mapGetters("profiles", [, "profiles", "profilesByStatus"]),
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
      }
    },
    methods: {
      emitFilterAction() {
        this.takeFilterAction()
        this.$emit("filter", this.filteredProfileIds, this.IsFiltering)
      },
      emitSelectedProfiles() {
        this.$emit("selection", this.selectedProfileIds)
      },
      emitValid(event, value) {
        this.$emit("valid", event, value)
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
        } else if (this.filterAction === "active_only") {
          this.filterProfiles(this.profilesByStatus.active.map((p) => p.id))
        } else if (this.filterAction === "incoming_only") {
          this.filterProfiles(this.profilesByStatus.incoming.map((p) => p.id))
        } else if (this.filterAction === "rejected_only") {
          this.filterProfiles(this.profilesByStatus.rejected.map((p) => p.id))
        } else if (this.filterAction === "finished_only") {
          this.filterProfiles(this.profilesByStatus.finished.map((p) => p.id))
        }
        this.filterAction = null
      },
      profileStatusLabel(profile) {
        if (profile.status === "rejected") return "Rejected"
        else if (profile.status === "finished") return "Finished"
        else if (profile.status === "incoming") return "Accepted"
        else return "Currently active"
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
          div.cell.name-cell(v-for="(label, key) in nameFields") {{label}}

      div.table-body
        div.row.placeholder-row
          div.cell.name-cell(v-for="(label, key) in nameFields")
        div.row(v-for="profile in displayedProfiles", :class="{'--selected': selectedProfileIdMap[profile.id]}")
          div.cell.name-cell.selection-box
            input(type="checkbox", :value="profile.id", v-model="selectedProfileIds", @change="emitSelectedProfiles")
          div.cell.name-cell(v-for="(label, key) in nameFields",
            :class="{'--rejected': profile.status === 'rejected', '--finished': profile.status === 'finished', '--incoming': profile.status === 'incoming'}",
            v-tooltip="{content: profileStatusLabel(profile), delay: {show: 900}}")
            static-field(:profile="profile", :field-name="key", @error="emit('error')", @valid="emitValid")


  </template>

  <style scoped>

  @import "../../init/variables.css";

  .names-table {

  }

  </style>
