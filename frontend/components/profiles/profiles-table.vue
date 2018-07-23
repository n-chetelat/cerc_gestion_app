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
      table
        thead
          tr
            th.header(v-for="(label, key) in staticFields")
              span {{label}}
            th.header(v-for="field in fields")
              span {{field.label}}
        tbody
          tr(v-for="profile in displayedProfiles", :class="{'--selected': selectedProfileIdMap[profile.id]}")
            td(v-for="(label, key) in staticFields")
              static-field(:profile="profile", :field-name="key", @error="$emit('error')", @valid="emitValid")
            td(v-for="field in fields")
              field(:profile="profile", :field="field", @error="$emit('error')", @valid="emitValid")


  </template>

  <style>

  @import "../../init/variables.css";

  .profiles-table {


  }

  </style>
