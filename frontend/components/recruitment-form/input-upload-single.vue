<script>
import FormFieldMixin from "../../mixins/form-field-mixin.js"

export default {
  name: "InputUploadSingle",
  mixins: [FormFieldMixin],
  methods: {
    onChange(files) {
      if (!files.length) return
      this.value = files[0]
    },
    removeFile() {
      this.value = null
    },
  }
}
</script>

<template lang="pug">
  div.input-upload-single
    label.label {{label}}
    input(type="file", accept=".pdf", @change="onChange($event.target.files)")
    p.file-list(v-if="value")
      span.file-line
        span {{value.name}}
        button.remove(type="button", @click="removeFile") x
</template>

<style>

</style>
