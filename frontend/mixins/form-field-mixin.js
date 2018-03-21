export default {
  props: {
    fieldId: {
      required: true
    },
    label: {
      required: true
    },
    options: {}
  },
  data() {
    return {
      value: null
    }
  }
}
