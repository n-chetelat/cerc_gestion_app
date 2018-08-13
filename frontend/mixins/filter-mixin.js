import { intersection } from "lodash-es"

export default {
  data() {
    return {
      filteredProfileIdsBySearch: [],
      filteredProfileIdsByMenu: [],
      filteredProfileIds: [],
      selectedProfileIds: [],
      filtering: false,
    }
  },
  computed: {
    joinedFilteredProfiles() {
      if (!this.filteredProfileIdsByMenu.length || !this.filteredProfileIdsBySearch.length) {
        return [...this.filteredProfileIdsByMenu,
          ...this.filteredProfileIdsBySearch]
      } else {
        return intersection(this.filteredProfileIdsBySearch,
          this.filteredProfileIdsByMenu)
      }
    }
  },
  methods: {
    filterProfiles(profileIds) {
      this.filteredProfileIds = profileIds
    },
    selectProfiles(profileIds) {
      this.selectedProfileIds = profileIds
    },
    onFilterBySearch(profileIds, filtering) {
      this.filtering = filtering
      this.filteredProfileIdsBySearch = profileIds
      this.filterProfiles(this.joinedFilteredProfiles)
    },
    onFilterByMenu(profileIds, filtering) {
      this.filtering = filtering
      this.filteredProfileIdsByMenu = profileIds
      this.filterProfiles(this.joinedFilteredProfiles)
    },
  }
}
