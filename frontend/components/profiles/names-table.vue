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
        ]
      }
    },
    computed: {
      ...mapGetters("profiles", [, "profiles"]),
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
    },
    methods: {
      emitFilterAction() {
        this.takeFilterAction()
        this.$emit("filter", this.filteredProfileIds)
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
    div.names-table

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
          div.cell.name-cell(v-for="(label, key) in nameFields")
            static-field(:profile="profile", :field-name="key", @error="emit('error')", @valid="emitValid")


  </template>

  <style>

  @import "../../init/variables.css";

  :root {
    --cellHeight: 55;
  }

  .names-table {
    position: absolute;
    background-color: white;
    z-index: 4;

    & .table-head {
      position: fixed;
      .cell {
        min-height: var(--cellMinHeight)px;
        margin: 0 auto;
        text-align: center;
        font-weight: bold;
      }
      & .row:first-of-type {
        & .name-cell {
          border-top: .5px solid black;
        }
      }
    }

    & .row {
      display: flex;
      &.--selected, &--selected .cell, &.--selected .name-cell {
        background-color: var(--highlightColor);
      }
    }

    & .cell {
      width: var(--cellWidth)em;
      height: var(--cellHeight)px;
      border: .5px solid;
      padding-top: var(--cellPadding)px;
      &.--invalid {
        background-color: var(--errorColor);
      }
    }

    & .table-body {
      & .row:last-of-type {
        & .name-cell {
          border-bottom: .5px solid black;
        }
      }
    }

    & .name-cell {
      border: .5px solid white;
      background-color: color(var(--themeColor) tint(40%));
    }

    & .selection-box {
      width: calc(var(--cellWidth)*var(--selectionBoxRatio))em;
      max-width: calc(var(--cellWidth)*var(--selectionBoxRatio))em;
      text-align: center;
      padding: var(--cellPadding)px;
      & input {
        width: auto;
      }
      & button {
        text-transform: none;
        padding: 0;
      }
      & select {
        width: 100%;
        font-size: .8em;
        border: none;
      }
    }

  }

  </style>
