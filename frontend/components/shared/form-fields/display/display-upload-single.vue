<script>

import DisplayFieldMixin from "../../../../mixins/display-field-mixin.js"

export default {
  name: "DisplayUploadSingle",
  mixins: [DisplayFieldMixin],
}
</script>

<template lang="pug">
  div.display-upload-single
    label {{field.label}}
    span(v-if="field.value && field.value.name")
      span.icon.pdf-icon
      a(:href="field.value.url", target="_blank") {{field.value.name | truncate(30)}}

</template>

<style>

</style>
