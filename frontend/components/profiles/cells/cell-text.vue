<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellText",
  mixins: [CellFieldMixin],
  methods: {
    async updateValue(event) {
      if (event.target.innerText === field.value) {
        return
      }
      const payload = {
        personProfileFieldId: this.field.id,
        newValue: event.target.innerText
      }
      try {
        await this.updateProfileData(payload)
      } catch(err) {
        this.$emit("error")
      }
    },
  }
}
</script>

<template lang="pug">
  span.cell-text(contenteditable, @blur="updateValue($event)") {{field.value}}

</template>

<style scoped>

</style>
