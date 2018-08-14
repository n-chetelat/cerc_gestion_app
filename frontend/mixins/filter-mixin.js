import { intersection } from "lodash-es"

import { mapActions } from "vuex"

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
    ...mapActions("csv", ["storeFilteredProfilesForCSV"]),
    filterProfiles(profileIds) {
      this.filteredProfileIds = profileIds
      this.storeFilteredProfilesForCSV(profileIds)
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
