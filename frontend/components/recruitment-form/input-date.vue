<script>

export default {
  name: "InputDate",
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
    input(type="date")
</template>

<style>

</style>
