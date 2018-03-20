<script>

export default {
  name: "InputText",
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
    input(type="text")
</template>

<style>

</style>
