<script>

export default {
  name: "InputRadio",
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
    input(type="radio")
</template>

<style>

</style>
