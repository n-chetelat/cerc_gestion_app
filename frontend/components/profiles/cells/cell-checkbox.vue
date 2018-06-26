<script>

import CellFieldMixin from "mixins/cell-field-mixin"


export default {
  name: "CellCheckbox",
  mixins: [CellFieldMixin],
  data() {
    return {
      fieldChoices: this.field.value || [],
    }
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
  span.cell-checkbox(:class="{'--editing': editing}",)
    ul.cell-display(v-if="!editing", @dblclick="editing = true")
      li.value(v-for="val in field.value") {{displayValue(val)}}
    select(v-else, multiple, v-model="fieldChoices", @change="updateValue($event, fieldChoices)", v-on-clickaway="closeEditing")
      option(:value="null") --
      option(v-for="choice in field.choices", :value="choice.id") {{choice.label}}

</template>

<style scoped>

  @import "../../../init/variables.css";

  .cell-checkbox {
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
