  <script>
  import { mapGetters } from "vuex"

  import StaticField from "components/profiles/static-field.vue"
  import Field from "components/profiles/field.vue"

  export default {
    name: "ProfilesTable",
    props: {
      displayedProfiles: { required: true },
      selectedProfileIds: { required: true },
      staticFields: {required: true },
      fields: { required: true },
    },
    data() {
      return {

      }
    },
    computed: {
      selectedProfileIdMap() {
        const profileIdMap = {}
        this.selectedProfileIds.forEach((id) => {
          profileIdMap[id] = id
        })
        return profileIdMap
      },
    },
    methods: {
      emitValid(event, value) {
        this.$emit("valid", event, value)
      },
    },
    components: {
      StaticField,
      Field,
    },
  }
  </script>

  <template lang="pug">
    div.profiles-table

      div.table-head
        div.row
          div.cell(v-for="(label, key) in staticFields")
            div {{label}}
          div.cell(v-for="field in fields")
            div {{field.label}}
      div.table-body
        div.row(v-for="profile in displayedProfiles", :class="{'--selected': selectedProfileIdMap[profile.id]}")
          div.cell(v-for="(label, key) in staticFields")
            static-field(:profile="profile", :field-name="key", @error="$emit('error')", @valid="emitValid")
          div.cell(v-for="field in fields")
            field(:profile="profile", :field="field", @error="$emit('error')", @valid="emitValid")



  </template>

  <style>

  @import "../../init/variables.css";

  :root {
    --cellHeight: 55;
  }

  .profiles-table {

    & .row {
      display: flex;
      &.--selected, &--selected .cell, &.--selected .name-cell {
        background-color: var(--highlightColor);
      }
    }

    & .cell {
      //- overflow: hidden;
      min-width: var(--cellWidth)em;
      width: var(--cellWidth)em;
      height: var(--cellHeight)px;
      border: 0.5px solid;
      padding-top: var(--cellPadding)px;
      &.--invalid {
        background-color: var(--errorColor);
      }
    }

    & .table-head {
      min-height: var(--cellMinHeight)px;
      margin: 0 auto;
      text-align: center;
      .cell {
        font-weight: bold;
      }
    }

  }

  </style>
