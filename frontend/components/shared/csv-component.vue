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
    }
  },
  computed: {
    ...mapGetters("csv", ["endpoint", "profilesForCSV", "fieldsForCSV"]),
    profileCSVEndpoint() {
      const profiles = this.profilesForCSV.map((p) => `profile_ids[]=${p}`).join("&")
      const fields = this.fieldsForCSV.map((f) => `field_ids[]=${f}`).join("&")
      const query = `${this.endpoint}.csv?${profiles}&${fields}`
      return query
    }
  },
  methods: {
    ...mapActions("csv", ["resetCSVFilters"]),
  },
}
</script>

<template lang="pug">
  div.csv
    button.csv-btn(type="button",
      v-tooltip="'CSV will contain selected columns and filtered profiles only.'")
      a(:href="profileCSVEndpoint") Export to CSV


</template>

<style>

@import "../../init/variables.css";

.csv {
  & .csv-btn {
    padding: 10px;
    text-transform: none;
    margin-left: 5px;
    border: 1px solid transparent;
    color: var(--navColor);
    &:hover {
      color: var(--navColor);
      border: 1px solid;
    }
    & a {
      color: white;
      &:hover {
        color: var(--navColor);
      }
    }
  }
}

</style>
