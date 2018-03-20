<script>

export default {
  name: "InputUpload",
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
    input(type="file", accept=".pdf")
</template>

<style>

</style>
