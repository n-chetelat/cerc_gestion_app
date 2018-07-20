<script>

import { mapGetters, mapActions } from "vuex"

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

  },
  methods: {
    onFilter() {
      var options = {
        shouldSort: true,
        threshold: 0.4,
        minMatchCharLength: 2,
        keys: [
          {name: "name", weight: 0.5},
          {name: "lastname", weight: 0.5},
          {name: "full_name", weight: 0.3}
        ],
        id: "id"
      }
      const fuse = new Fuse(this.collection, options)
      this.filteredIds = fuse.search(this.q)
      this.$emit("filter", this.filteredIds)
    }
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
