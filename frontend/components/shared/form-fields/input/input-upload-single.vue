<script>
import FormFieldMixin from "../../../../mixins/form-field-mixin.js"

import { mapGetters } from "vuex"

export default {
  name: "InputUploadSingle",
  mixins: [FormFieldMixin],
  data() {
    return {
      invalidDataType: false,
      translations: {
        invalid: {en: "Only PDF format is accepted", fr: "Seulement le format PDF est accepté"}
      }
    }
  },
  computed: {
    ...mapGetters("locales", ["currentLocale"]),
    fieldData() {
      if (this.value && this.value.constructor === Object) {
        return this.value.name
      }
      return this.value
    },
    formatIsValid() {
      return !this.value ||
        this.value.constructor === Object ||
        (this.value && this.value.type === "application/pdf")
    },
    isValid() {
      if (!this.options.optional) {
        return !!(this.value && this.formatIsValid)
      } else {
        return (this.value) ? this.formatIsValid : true
      }
    },
  },
  methods: {
    onChange(files) {
      if (!files.length) return
      if (files[0].type !== "application/pdf") {
        this.value = null
        this.invalidDataType = true
        return
      }
      this.invalidDataType = false
      this.value = files[0]
      this.$emit("input")
    },
    removeFile() {
      this.value = null
      this.$emit("input")
    },
  }
}
</script>

<template lang="pug">
  div.input-upload-single
    label.label {{label}}
      span (pdf)
    input(type="file", accept=".pdf", @change="onChange($event.target.files)")
    p.invalid-msg(v-if="invalidDataType") {{translations.invalid[currentLocale]}}
    p.file-list(v-if="fieldData")
      span.file-line
        span {{value.name | truncate(30)}}
        button.remove(type="button", @click="removeFile")
</template>

<style>

.input-upload-single {
  & label span {
    font-size: .8em;
    margin-left: 3px;
  }

  & .invalid-msg {
    font-size: .8em;
    color: red;
    text-align: center;
  }
}

</style>
