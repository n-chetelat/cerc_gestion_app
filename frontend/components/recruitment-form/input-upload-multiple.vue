<script>
import FormFieldMixin from "../../mixins/form-field-mixin.js"
import axios from "axios"
import { find, difference } from "lodash-es"

export default {
  name: "InputUploadMultiple",
  mixins: [FormFieldMixin],
  data() {
    return {
      fileList: [],
    }
  },
  computed: {
    inputName() {
      return `input_upload_multiple_${this.fieldId}`
    },
  },
  methods: {
    onChange(files) {
      if (!files.length) return

      const that = this
      Array.from(Array(files.length).keys()).map((index) => {
        if (!find(that.fileList, (file) =>  file.name === files[index].name)) {
          that.fileList.push(files[index])
        }
      })
    },
    removeFile(file) {
      this.fileList = difference(this.fileList, [file])
    },
    // send() {
    //   this.value = new FormData()
    //   this.fileList.forEach((file, index) => {
    //     this.value.append(`${this.inputName}[${index}]`, file, file.name)
    //   })
    //   axios.post("/", this.value).then((h) => {debugger})
    // },
  }
}
</script>

<template lang="pug">
  div
    label.label {{label}}
    input(type="file", accept=".pdf", multiple, @change="onChange($event.target.files)")
    ul.file-list
      li(v-for="file in fileList") {{file.name}}
        button.remove(type="button", @click="removeFile(file)") x
</template>

<style>

  .file-list {
    list-style: none;
    max-width: 20em;
    margin: auto;
  }

  .file-list li {
    margin-top: 3px;
  }

  .remove {
    margin: auto 15px;
    width: 1.7em;
    height: 1.7em;
    padding: 2px;
  }

</style>
