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
        "To filter by:",
        "- Status:<br>Status::&lt;status name&gt; (active, incoming, rejected, or finished)",
        "- Milestone name:<br>Milestone::&lt;milestone name&gt;",
        "- Column - separate column name and value with two colons (::):<br>&lt;column name 1&gt;::&lt;value 1&gt;",
        "- Exact date:<br>&lt;date column name&gt;::&lt;date value&gt; (ex: winter 2019, july 4 2070)",
        "- Before a date - add 'less than' sign (&lt;):<br>&lt;date column name&gt;::&lt;&lt;date name&gt;",
        "- After a date - add 'greater than' sign (&gt;):<br>&lt;date column name&gt;::&gt;&lt;date name&gt;",
        "- Milestone date:<br>As for any other dates, but with column name 'Milestone date' (ex: milestone date::winter 2017)",
        "To add multiple search terms by column (multi-choice fields only):<br>&lt;column name&gt;::&lt;value 1&gt;, &lt;value 2&gt;",
        "To use many filters, separate by semicolon (;):<br>&lt;term 1&gt;; &lt;term 2&gt;; &lt;column name 1&gt::&lt;value 1&gt;",
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
