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
    ...mapActions("filters", ["filterProfiles"]),
    onFilter: _.throttle(function() {
      this.searchITemsToFilter()
      this.$emit("filter", this.filteredIds)
    }, 500),
    async searchITemsToFilter() {
      await this.filterProfiles({q: this.q}).then(() => {
        if (!this.filteredProfileIds.length) {
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
      input(type="text", v-model="q", @input="onFilter")


</template>

<style>

@import "../../init/variables.css";

.search {

}

</style>
