<script>

export default {
  name: "InputCheckbox",
  props: {
    label: {
      required: true
    },
    options: {}
  }
}
</script>

<template lang="pug">
  div
    label.label {{label}}
    input(type="checkbox")
</template>

<style>

</style>
