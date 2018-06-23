import { keyBy } from "lodash-es"

export default {
  props: {
    field: {
      required: true
    },
  },
  computed: {
    choicesById() {
      if (this.field.choices) {
        return keyBy(this.field.choices, "id")
      }
      return null
    }
  }
}
