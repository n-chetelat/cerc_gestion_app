<script>

import CellFieldMixin from "mixins/cell-field-mixin"

export default {
  name: "CellTextarea",
  mixins: [CellFieldMixin],
  data() {
    return {
      textValue: this.field.value,
      popupLeft: 0,
      popupTop: 0,
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
  },
  methods: {
    setNewValue(event) {
      this.closeEditing()
      this.updateValue(event, this.textValue)
    },
    onEditing() {
      if (this.editing) { this.editing = false}
      else {
        this.popupTop = this.getPopupTop()
        this.popupLeft = this.getPopupLeft()
        this.editing = true
      }
    },
    getPopupLeft() {
      return this.$el.getBoundingClientRect().left
    },
    getPopupTop() {
      return this.$el.getBoundingClientRect().top
    }
  },
}
</script>

<template lang="pug">

  span.cell-textarea
    span.cell-display(v-if="!editing", @dblclick="onEditing") {{displayValue}}

    div.textarea-popup(v-else, :style="{left: popupLeft + 'px', top: popupTop + 'px'}")
      textarea(v-model="textValue", v-on-clickaway="closeEditing", @blur="setNewValue($event)", placeholder="'Write in some text...'") {{textValue}}

</template>

<style>

@import "../../../init/variables.css";

.cell-textarea {
  & .textarea-popup, .textarea-popup textarea {
    min-width: var(--cellWidth)em;
    min-height: calc(var(--cellMinHeight) * 3)px;
    width: var(--cellWidth)em;
    height: calc(var(--cellMinHeight) * 3)px;
    border-radius: 5px;
  }
  & .textarea-popup {
    position: fixed;
  }
  & .textarea-popup textarea {
    background-color: white;
    border: 2px solid var(--themeColor);
    padding: 5px;
  }
}

</style>
