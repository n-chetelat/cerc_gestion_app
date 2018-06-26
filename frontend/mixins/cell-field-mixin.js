import { keyBy } from "lodash-es"

import { mapActions } from "vuex"

import { mixin as clickaway } from 'vue-clickaway'

export default {
  mixins: [clickaway],
  props: {
    field: {
      required: true
    },
    profile: {
      required: true
    }
  },
  data() {
    return {
      editing: false,
    }
  },
  computed: {
    choicesById() {
      if (this.field.choices) {
        return keyBy(this.field.choices, "id")
      }
      return null
    },
    isValid() {
      return true
    }
  },
  methods: {
    ...mapActions("profiles", ["createProfileData", "updateProfileData"]),
    async updateValue(event, newValue) {
      if (!this.isValid) {
        this.$emit("valid", event, false)
        return
      }
      this.$emit("valid", event, true)
      if (newValue === this.field.value) return

      try {
        if (this.field.id) {
          await this.updateProfileData({ personProfileFieldId: this.field.id, newValue })
        } else {
          await this.createProfileData({
            personId: this.profile.uuid,
            profileFieldId: this.field.profile_field_id,
            newValue
          })
        }
      } catch(err) {
        this.$emit("server-error")
      }
    },
    closeEditing() {
      this.editing = false
    }
  }
}
