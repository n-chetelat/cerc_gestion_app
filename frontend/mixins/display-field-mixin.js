import { keyBy } from "lodash-es"

export default {
  props: {
    field: {
      required: true
    },
    options: {}
  },
  computed: {
    choicesById() {
      if (this.options && this.options.choices) {
        return keyBy(this.options.choices, "id")
      }
      return null
    }
  }
}
