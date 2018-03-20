<script>

export default {
  name: "InputSelect",
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
    select
</template>

<style>

</style>
