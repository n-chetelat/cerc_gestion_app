<script>

import { mapGetters, mapActions } from "vuex"

import _ from "lodash-es"

import * as Fuse from "fuse.js"

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
    ...mapGetters("filters", ["filteredProfileIds"])
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
  components: {
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
      input(type="text", v-model="q", @keyup.enter="onFilter")
      button.filter-btn(type="button", @click="onFilter") Go


</template>

<style>

@import "../../init/variables.css";

.search {
  & .filter-btn {
    padding: 10px;
    margin-left: 5px;
  }
}

</style>
