<script>

import DisplayFieldMixin from "../../../mixins/display-field-mixin"

export default {
  name: "DisplayRadio",
  mixins: [DisplayFieldMixin],
}
</script>

<template lang="pug">
  div.display-radio
    label {{field.label}}
    span {{field.value}}

</template>

<style>

</style>
