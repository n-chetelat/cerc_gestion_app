<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellTextarea",
  mixins: [CellFieldMixin],
  data() {
    return {
      textValue: this.field.value,
    }
  },
  computed: {
    isValid() {
      if (!this.field.optional) {
        return !!(this.textValue && this.textValue.length)
      }
      return true
    },
    displayValue() {
      if (this.field.value) {
        const truncated = `${this.field.value.substring(0, 40)}${this.field.value.length > 40 ? '...' : ''}`
        return this.editing ? this.field.value : truncated
      }
    },
    popupLeft() {
      return this.$el.getBoundingClientRect().left
    },
    popupTop() {
      return this.$el.getBoundingClientRect().top
    }
  },
  methods: {
    setNewValue(event) {
      this.closeEditing()
      this.updateValue(event, this.textValue)
    },
  }
}
</script>

<template lang="pug">

  span.cell-textarea
    span.cell-display(v-if="!editing", @dblclick="editing = true") {{displayValue}}
    //- textarea(v-else, v-model="textValue", v-on-clickaway="closeEditing", @blur="setNewValue($event)") {{textValue}}

    div.textarea-popup(v-else, :style="{left: popupLeft, top: popupTop}")
      textarea(v-model="textValue", v-on-clickaway="closeEditing", @blur="setNewValue($event)", placeholder="'Write in some text...'") {{textValue}}

</template>

<style>

@import "../../../init/variables.css";

.textarea-popup, .textarea-popup textarea {
  min-width: var(--cellWidth)em;
  min-height: calc(var(--cellMinHeight) * 3)px;
  width: var(--cellWidth)em;
  height: calc(var(--cellMinHeight) * 3)px;
  border-radius: 5px;
}
.textarea-popup {
  position: fixed;
}

.cell-textarea {
  & .textarea-popup textarea {
    min-width: var(--cellWidth)em; /* need to repeat due to more specific rule */
    background-color: white;
    border: 2px solid var(--themeColor);
    padding: 5px;
  }
}

</style>
