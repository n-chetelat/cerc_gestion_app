<script>

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

export default {
  name: "DisplayUploadSingle",
  mixins: [DisplayFieldMixin],
}
</script>

<template lang="pug">
  div.display-upload-single
    label {{field.label}}
    span(v-if="field.value.name")
      span.icon.pdf-icon
      a(:href="field.value.url", target="_blank") {{field.value.name}}

</template>

<style>

</style>
