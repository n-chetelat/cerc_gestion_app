  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"
import FilterMixin from "mixins/filter-mixin.js"

import { mapGetters, mapActions } from "vuex"
import { groupBy } from "lodash-es"

import AdminNav from "components/shared/admin-nav.vue"
import NamesTable from "components/timeline/names-table.vue"
import TimelineTable from "components/timeline/timeline-table.vue"

import ServerErrorModal from "./boards/modals/server-error.vue"
import ProfileMilestonesModal from "./timeline/modals/profile-milestones.vue"

  export default {
    name: "Timeline",
    mixins: [SceneMixin, ModalMixin, FilterMixin],
    async created() {
      try {
        await this.fetchActiveProfileTimelineDates()
        await Promise.all([
          this.fetchMilestones(), this.fetchProfiles(),
          this.getAllPositions(), this.fetchProfileFields(),
          this.fetchMonths({extended: true}),
          this.fetchSemesters({extended: true})
        ])
        await this.fetchPersonMilestones()
      } catch (err) {
        this.openModal("server-error", {})
      }
    },
    updated() {
      const timelineTable = document.querySelector(".timeline-table")
      const currentHeader = document.querySelector("th.--current")
      if (timelineTable && currentHeader) {
        timelineTable.scrollBy(-(timelineTable.scrollWidth), 0)
        timelineTable.scrollBy(currentHeader.offsetLeft, 0)
      }
    },
    data() {
      return {
        currentProfileInModal: null,
        currentTabInModal: null,
        selectedFields: [],
      }
    },
    computed: {
      ...mapGetters("profiles", [, "profiles"]),
      ...mapGetters("milestones", ["milestonesById", "milestonesByPersonId"]),
      ...mapGetters("dates", ["timelineDates"]),
      filteredProfiles() {
        if (!this.profiles) return []
        if (!this.filteredProfileIds.length) return this.profiles
        return filter(this.profiles, (p) => this.filteredProfileIds.includes(p.id))
      },
      timelineTableMinHeight() {
        const cellMaxHeight = 55
        const headerHeight = 122
        return (this.profiles.length + 1) * cellMaxHeight + headerHeight
      },
    },
    methods: {
      ...mapActions("milestones", ["fetchMilestones", "fetchPersonMilestones"]),
      ...mapActions("profiles", ["fetchProfiles", "fetchProfileFields"]),
      ...mapActions("dates", ["fetchSemesters", "fetchMonths", "fetchActiveProfileTimelineDates"]),
      ...mapActions("positions", ["getAllPositions"]),
      openModalByName(modalName, data={}) {
        if (modalName === "profile-milestones") {
          this.currentProfileInModal = data.profile
          this.currentTabInModal = data.tab
        }
        this.openModal(modalName)
      },
      closeModal() {
        this.modalVisible = false
        this.modalName = null
        if (this.currentProfileInModal) this.currentProfileInModal = null
      },
    },
    components: {
      ServerErrorModal,
      AdminNav,
      NamesTable,
      TimelineTable,
      ProfileMilestonesModal
    }
  }
  </script>

  <template lang="pug">
    div.timeline
      server-error-modal(@close="closeModal", v-if="modalVisible && modalName === 'server-error'")
      profile-milestones-modal(@close="closeModal", v-if="modalVisible && modalName === 'profile-milestones'", :profile="currentProfileInModal", :tab="currentTabInModal")

      admin-nav(@filter="filterProfiles")

      div.tables
        names-table(:displayed-profiles="filteredProfiles",
          @filter="filterProfiles",
          @selection="selectProfiles",
          @modal="openModalByName",
          @error="openModalByName('server-error')")

        timeline-table.dynamic-table(
          :displayed-profiles="filteredProfiles",
          :selected-profile-ids="selectedProfileIds",
          :timeline-dates="timelineDates",
          @error="openModalByName('server-error')",
          @modal="openModalByName",
          :style="{minHeight: `${timelineTableMinHeight}px`}")

  </template>

  <style>

  @import "../init/variables.css";

  :root {
    --timelineTableOffset: calc(var(--cellWidth)*(1+var(--selectionBoxRatio)));
  }

  .timeline {
    display: flex;
    flex-direction: column;
    flex-wrap: nowrap;
    height: 100%;

    & .tables {
      width: 100%;
    }

    & .timeline-table {
      position: absolute;
      left: var(--timelineTableOffset)em;
      width: calc(100% - var(--timelineTableOffset)em);
    }



  }

  </style>
