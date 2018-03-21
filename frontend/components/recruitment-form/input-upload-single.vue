<script>

export default {
  name: "InputUploadSingle",
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
