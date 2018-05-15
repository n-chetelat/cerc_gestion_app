<script>

import DisplayFieldMixin from "../../../../mixins/display-field-mixin.js"

export default {
  name: "DisplayUploadMultiple",
  mixins: [DisplayFieldMixin],
}
</script>

<template lang="pug">
  div.display-upload-multiple
    label {{field.label}}
    ul
      li.value(v-for="val in field.value")
        span.icon.pdf-icon
        a(:href="val.url", target="_blank") {{val.name | truncate(30)}}

</template>

<style>

</style>
