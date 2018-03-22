<script>
import FormFieldMixin from "../../mixins/form-field-mixin.js"

export default {
  name: "InputUploadSingle",
  mixins: [FormFieldMixin],
  computed: {
    inputName() {
      return `input_upload_single_${this.fieldId}`
    }
  },
  methods: {
    onChange(files) {
      if (!files.length) return
      const formData = new FormData()
      formData.append(this.inputName, files[0], files[0].name)
      this.value = formData
    }
  }
}
</script>

<template lang="pug">
  div
    label.label {{label}}
    input(type="file", accept=".pdf", @change="onChange($event.target.files)")
</template>

<style>

</style>
