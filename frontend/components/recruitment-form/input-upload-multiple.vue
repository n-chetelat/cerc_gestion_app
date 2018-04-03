<script>
import FormFieldMixin from "../../mixins/form-field-mixin.js"

import { find, difference } from "lodash-es"

export default {
  name: "InputUploadMultiple",
  mixins: [FormFieldMixin],
  data() {
    return {
      value: [],
    }
  },
  computed: {
    isValid() {
      if (!this.options.optional) {
        return !!this.value.length
      }
      return true
    }
  },
  methods: {
    onChange(files) {
      this.$emit("input")
      if (!files.length) return

      const that = this
      Array.from(Array(files.length).keys()).map((index) => {
        if (!find(that.value, (file) =>  file.name === files[index].name)) {
          that.value.push(files[index])
        }
      })
    },
    removeFile(file) {
      this.value = difference(this.value, [file])
    },
  }
}
</script>

<template lang="pug">
  div.input-upload-multiple
    label.label {{label}}
    input(type="file", accept=".pdf", multiple, @change="onChange($event.target.files)")
    ul.file-list
      li.file-line(v-for="file in value")
        span {{file.name}}
        button.remove(type="button", @click="removeFile(file)") x
</template>

<style>

</style>
