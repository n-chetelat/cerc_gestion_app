export default {
  data() {
    return {
      filteredProfileIds: [],
      selectedProfileIds: [],
    }
  },
  computed: {
  },
  methods: {
    filterProfiles(profileIds) {
      this.filteredProfileIds = profileIds
    },
    selectProfiles(profileIds) {
      this.selectedProfileIds = profileIds
    },
  }
}
