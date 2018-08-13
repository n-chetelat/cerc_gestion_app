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
      numSelectedFields: { required: true }
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
      scrollHeaderSideways() {
        const body = this.$el.querySelector(".table-body")
        const head = this.$el.querySelector(".table-head")
        const leftEdge = body.getBoundingClientRect().x
        head.setAttribute("style", `left: ${leftEdge}px;`)
      }
    },
    components: {
      StaticField,
      Field,
    },
  }
  </script>

  <template lang="pug">
    div.table.profiles-table(@scroll="scrollHeaderSideways")

      div.table-head
        div.row
          div.cell(v-for="(label, key) in staticFields")
            div {{label}}
          div.cell(v-for="field in fields")
            div {{field.label}}
      div.table-body
        div.row.placeholder-row
          div.cell(v-for="n in numSelectedFields")
        div.row(v-for="profile in displayedProfiles", :class="{'--selected': selectedProfileIdMap[profile.id]}")
          div.cell(v-for="(label, key) in staticFields")
            static-field(:profile="profile", :field-name="key", @error="$emit('error')", @valid="emitValid")
          div.cell(v-for="field in fields")
            field(:profile="profile", :field="field", @error="$emit('error')", @valid="emitValid")



  </template>

  <style>

  @import "../../init/variables.css";

  .profiles-table {

  }

  </style>
