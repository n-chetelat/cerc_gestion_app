<script>

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

export default {
  name: "DisplayUploadSingle",
  mixins: [DisplayFieldMixin],
}
</script>

<template lang="pug">
  div.display-text
    p {{field.label}}

</template>

<style>

</style>
