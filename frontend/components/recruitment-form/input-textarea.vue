<script>

export default {
  name: "InputTextarea",
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
    textarea
</template>

<style>

</style>
