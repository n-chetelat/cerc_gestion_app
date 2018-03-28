<script>

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

export default {
  name: "DisplayText",
  mixins: [DisplayFieldMixin],
}
</script>

<template lang="pug">
  div.display-text
    p {{field.label}}

</template>

<style>

</style>
