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
    },
    editable: {
      default: true
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
  },
  methods: {
    ...mapActions("profiles", ["createProfileData", "updateProfileData", "updatePersonData"]),
    ...mapActions("milestones", ["fetchPersonMilestones"]),
    async updateValue(event, newValue) {
      if (!this.isValid) {
        this.$emit("valid", event, false)
        return
      }
      this.$emit("valid", event, true)
      if (newValue === this.field.value) return

      try {
        if (!this.field.profile_field_id) {
          await this.updatePersonData({ personId: this.profile.uuid,
            field: this.field.fieldName,
            newValue
          })
          if (this.field.fieldName === "position_id") {
            await this.fetchPersonMilestones()
          }
        }
        else if (this.field.id) {
          await this.updateProfileData({ personId: this.profile.uuid,
            personProfileFieldId: this.field.id, newValue })
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
