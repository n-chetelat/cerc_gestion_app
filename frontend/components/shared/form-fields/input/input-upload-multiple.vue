<script>
import FormFieldMixin from "../../../../mixins/form-field-mixin.js"

import { find, difference, filter, every, some } from "lodash-es"

export default {
  name: "InputUploadMultiple",
  mixins: [FormFieldMixin],
  data() {
    return {
      value: [],
      invalidDataType: false,
    }
  },
  computed: {
    fieldData() {
      return this.value.map((val) => {
        if (val.constructor === Object) {
          return val.name
        }
        return val
      })
    },
    formatIsValid() {
      return !this.value.length ||
        every(this.value, (val) => {
          return val.constructor === Object ||
            val.type === "application/pdf"
        })
    },
    isValid() {
      if (!this.options.optional) {
        return !!(this.value.length && this.formatIsValid)
      } else {
        return (this.value.length) ? this.formatIsValid : true
      }
    },
  },
  methods: {
    onChange(files) {
      this.$emit("input")
      if (!files.length) return
      if (some(files, (file) => file.type !== "application/pdf")) {
        this.invalidDataType = true
        return
      }
      this.invalidDataType = false
      const that = this
      Array.from(Array(files.length).keys()).map((index) => {
        if (!find(that.value, (file) =>  file.name === files[index].name)) {
          that.value.push(files[index])
        }
      })
      this.$emit("input")
    },
    removeFile(file) {
      this.value = difference(this.value, [file])
      this.$emit("input")
    },
  }
}
</script>

<template lang="pug">
  div.input-upload-multiple
    label.label {{label}}
      span (pdf)
    input(type="file", accept=".pdf", multiple, @change="onChange($event.target.files)")
    p.invalid-msg(v-if="invalidDataType") Only PDF format is accepted.
    ul.file-list
      li.file-line(v-for="file in value")
        span {{file.name | truncate(30)}}
        button.remove(type="button", @click="removeFile(file)")
</template>

<style>

  .input-upload-multiple {
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
