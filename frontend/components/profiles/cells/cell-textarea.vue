<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellTextarea",
  mixins: [CellFieldMixin],
  methods: {
    async updateValue(event) {
      if (event.target.innerText === this.field.value) {
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
  span.cell-textarea(contenteditable, @blur="updateValue($event)") {{field.value}}

</template>

<style>

@import "../../../init/variables.css";

  .cell-textarea {
    overflow-y: auto;
    overflow-x: hidden;
    font-family: var(--textFamily);
    font-size: .9em;
    line-height: 1.3em;
    display: inline-block;
    width: 20em;
  }

</style>
