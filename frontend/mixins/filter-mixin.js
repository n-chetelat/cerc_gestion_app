import { mapGetters } from "vuex"
import { filter } from "lodash-es"

export default {
  data() {
    return {
      filteredProfileIds: [],
      selectedProfileIds: [],
      filterAction: null,
      filterActions: [
        {id: "show_all", label: "Show all"},
        {id: "show_selected", label: "Show selected"},
        {id: "deselect_all", label: "Deselect all"},
      ]
    }
  },
  computed: {
    ...mapGetters("profiles", ["profiles"]),
    filteredProfiles() {
      if (!this.profiles) return []
      if (!this.filteredProfileIds.length) return this.profiles
      return filter(this.profiles, (p) => this.filteredProfileIds.includes(p.id))
    },
    selectedProfileIdMap() {
      const profileIdMap = {}
      this.selectedProfileIds.forEach((id) => {
        profileIdMap[id] = id
      })
      return profileIdMap
    }
  },
  methods: {
    filterProfiles(profileIds) {
      this.filteredProfileIds = profileIds
    },
    takeFilterAction() {
      if (!this.filterAction) return
      if (this.filterAction === "show_all") {
        this.filterProfiles(this.profiles.map((p) => p.id))
      } else if (this.filterAction === "show_selected") {
        this.filterProfiles(this.selectedProfileIds)
      } else if (this.filterAction === "deselect_all") {
        this.selectedProfileIds = []
      }
      this.filterAction = null
    }
  }
}
