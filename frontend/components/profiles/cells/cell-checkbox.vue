<script>

import CellFieldMixin from "mixins/cell-field-mixin"

import { compact } from "lodash-es"


export default {
  name: "CellCheckbox",
  mixins: [CellFieldMixin],
  data() {
    return {
      fieldChoices: this.field.value || [],
    }
  },
  computed: {
    isValid() {
      const choiceIds = this.field.choices.map(s => s.id)
      const allInChoices = this.fieldChoices.every(fc =>  choiceIds.includes(fc))
      const valuesEmpty = !(compact(this.fieldChoices).length)
      if (this.field.optional) return valuesEmpty || allInChoices
      else return !valuesEmpty && allInChoices
    },
  },
  methods: {
    displayValue(val) {
      return this.choicesById &&
        this.choicesById[val] &&
        this.choicesById[val].label
    }
  }
}
</script>

<template lang="pug">
  span.cell-checkbox(:class="{'--editing': editing}")
    ul.cell-display(v-if="!editing", @dblclick="editing = true")
      li.value(v-for="val in field.value") {{displayValue(val)}}
    select(v-else, multiple, v-model="fieldChoices", @change="updateValue($event, fieldChoices)", v-on-clickaway="closeEditing")
      option(:value="null", v-if="field.optional") --
      option(v-for="choice in field.choices", :value="choice.id") {{choice.label}}

</template>

<style scoped>

  @import "../../../init/variables.css";

  .cell-checkbox {
    &.--editing {
      z-index: 100;
      background-color: white;
    }

    & ul {
      text-align: left;
    }
    & ul li {
      &:before {
        content: "\25E6 ";
        color: var(--themeColor);
      }
    }
  }

</style>
