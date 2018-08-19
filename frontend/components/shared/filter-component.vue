<script>

import { mapGetters, mapActions } from "vuex"

import _ from "lodash-es"

export default {
  name: "FilterComponent",
  props: {
    collection: { default: () => [] }
  },
  data() {
    return {
      q: "",
      filteredIds: []
    }
  },
  computed: {
    ...mapGetters("filters", ["filteredProfileIds"]),
    filterInstructions() {
      const instructions = [
        "To filter by status:<br>Status::'status name' (active, incoming, rejected, or finished)",
        "To filter by column, separate column name and value with two colons (::):<br>Column Name 1::Value1",
        "To add multiple search terms by column (multi-choice fields only):<br>Column Name::Value1, Value2",
        "To filter by exact date:<br>Date Column Name::date name (ex. june 2019, winter 2030, july 5 2019)",
        "To filter by before a date:<br>Date Column Name::&lt;date name",
        "To filter by after a date:<br>Date Column Name::&gt;date name",
        "To use many filters, separate by semicolon (;):<br>Term1; Term2; Column1::value1; Column2::value2"
      ]
      return instructions.join("<br><br>")
    },
  },
  methods: {
    ...mapActions("filters", ["filterProfilesByQueryString"]),
    onFilter() {
      this.searchITemsToFilter().then(() => {
        const filtering = !!this.q.length
        this.$emit("filter", this.filteredIds, filtering)
      })
    },
    searchITemsToFilter() {
      return this.filterProfilesByQueryString({q: this.q}).then(() => {
        if (!this.q) {
          this.filteredIds = this.collection.map((p) => p.id)
        } else {
          this.filteredIds = this.filteredProfileIds
        }
      })
    },
  },
  watch: {
    'collection' (val, oldVal) {
      if (oldVal.length) return // Trigger only on transition from empty array to full
      if (val.length) {
        this.filteredIds = this.collection.map((c) => c.id)
      }
    }
  }
}
</script>

<template lang="pug">
    div.search
      label Filter
      input(type="text", v-model="q", @keyup.enter="onFilter", placeholder="Ex. Kim Lee PhD; Starting Date::Winter 2021")
      button.filter-btn(type="button", @click="onFilter") Go
      div.info(v-tooltip="filterInstructions")


</template>

<style>

@import "../../init/variables.css";

.search {
  & .filter-btn {
    padding: 10px;
    margin-left: 5px;
    border: 1px solid transparent;
    &:hover {
      border: 1px solid;
    }
  }

  & .info {
    height: 1.8em;
    width: 1.8em;
    margin-left: 5px;
    padding: .6em;
    display: inline-flex;
    background: url("../../static/icons/info.svg") center center / 100% no-repeat;
  }
}

</style>
