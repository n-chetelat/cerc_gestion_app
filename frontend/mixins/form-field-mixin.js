export default {
  props: {
    fieldId: {
      required: true
    },
    fieldType: {
      required: true
    },
    label: {
      required: true
    },
    savedValue: {},
    options: {}
  },
  data() {
    return {
      value: null
    }
  },
  created() {
    if (this.savedValue) {
      this.value = this.savedValue
    }
  },
  computed: {
    fieldData() {
      return this.value
    },
    inputName() {
      return `${this.fieldType.replace(/-/g, "_")}_${this.fieldId}`
    },
    isValid() {
      if (!this.options.optional) {
        return !!this.value
      }
      return true
    }
  },
  methods: {
    onInput() {
      this.$emit("input")
    }
  }
}
