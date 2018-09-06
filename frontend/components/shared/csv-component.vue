<script>

import { mapGetters, mapActions } from "vuex"

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
  span.csv
    a.csv-link(:href="profileCSVEndpoint",
      v-tooltip="'CSV will contain selected columns and filtered profiles only.'") Export to CSV


</template>

<style>

@import "../../init/variables.css";

.csv {
  padding-top: .7em;
  & .csv-link {
    margin-left: 5px;
    color: var(--navColor);
    &:hover {
      color: var(--navColor);
    }
  }
}

</style>
