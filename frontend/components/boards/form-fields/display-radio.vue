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
    span {{choicesById[field.value] && choicesById[field.value].label}}

</template>

<style>

</style>
