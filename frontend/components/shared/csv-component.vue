<script>

import { mapGetters, mapActions } from "vuex"

import _ from "lodash-es"

export default {
  name: "CsvComponent",
  created() {
    this.resetCSVFilters()
  },
  data() {
    return {
      generating: false,
    }
  },
  computed: {
    ...mapGetters("csv", ["profilesForCSV", "fieldsForCSV"])
  },
  methods: {
    ...mapActions("csv", ["createCSVFile", "resetCSVFilters"]),
    createCSV() {
      this.generating = true
      this.createCSVFile().then(() => {this.generating = false})
    }
  },
}
</script>

<template lang="pug">
  div.csv
    button.csv-btn(type="button", @click="createCSV", :disabled="generating"
      v-tooltip="'CSV will contain selected columns and filtered profiles only.'") Export to CSV


</template>

<style>

@import "../../init/variables.css";

.csv {
  & .csv-btn {
    padding: 10px;
    text-transform: none;
    margin-left: 5px;
    border: 1px solid transparent;
    &:hover {
      border: 1px solid;
    }
  }
}

</style>
