  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { mapGetters, mapActions } from "vuex"
import { groupBy, filter } from "lodash-es"

import ServerErrorModal from "./boards/modals/server-error.vue"
import MilestoneCell from "./timeline/milestone-cell.vue"
import AdminNav from "components/shared/admin-nav.vue"
import ProfileMilestonesModal from "./timeline/modals/profile-milestones.vue"

  export default {
    name: "Timeline",
    mixins: [SceneMixin, ModalMixin],
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
        filteredProfileIds: [],
        selectedProfileIds: [],
        filterAction: null
      }
    },
    computed: {
      ...mapGetters("milestones", ["milestonesById", "milestonesByPersonId"]),
      ...mapGetters("profiles", ["profiles"]),
      ...mapGetters("dates", ["timelineDates"]),
      ...mapGetters("positions", ["allPositionsById"]),
      currentDate() {
        const today = new Date
        const month = `${today.getMonth() + 1}`.padStart(2, "0")
        const date = `${today.getFullYear()}-${month}-01`
        return date
      },
      milestonesBySemester() {
        const structure = {}
        this.profiles.forEach((profile) => {
          structure[profile.uuid] = groupBy(this.milestonesByPersonId[profile.uuid], (m) => m.semester)
        })
        return structure
      },
      timelineTableMinHeight() {
        const cellMaxHeight = 62
        const headerHeight = 122
        return (this.profiles.length + 1) * cellMaxHeight + headerHeight
      },
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
      isCurrentSemester(semester) {
        const dates = [semester.id, ...semester.months.map(m => m.id)]
        return dates.includes(this.currentDate)
      },
      milestonesForSemester(profile, semester) {
        if (!this.milestonesBySemester[profile.uuid]) return null
        return this.milestonesBySemester[profile.uuid][semester.id]
      },
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
    },
    components: {
      ServerErrorModal,
      MilestoneCell,
      AdminNav,
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
        div.names-table
          table
            thead
              tr
                th.selection-box
                  select(v-model="filterAction", @change="takeFilterAction")
                    option(:value="null") -- Actions --
                    option(:value="'show_all'") Show all
                    option(:value="'show_selected'") Show selected
                    option(:value="'deselect_all'") Deselect all
                th
                  div.header-content Name
            tbody
              tr(v-for="profile in filteredProfiles", :class="{'--selected': selectedProfileIdMap[profile.id]}")
                td.selection-box
                  input(type="checkbox", :value="profile.id", v-model="selectedProfileIds")
                td
                  div.cell-content(@click="openModalByName('profile-milestones', { profile })") {{profile.full_name}}
                    div.person-position-label {{allPositionsById[profile.position_id].title}}

        div.dynamic-table.timeline-table(:style="{minHeight: `${timelineTableMinHeight}px`}")
          table
            thead
              tr
                th(v-for="date in timelineDates", :class="{'--current': isCurrentSemester(date)}")
                  div.header-content
                    p {{date.label}}
                    span.months-label {{date.months[0].label}} - {{date.months[date.months.length-1].label}}
            tbody
              tr(v-for="profile in filteredProfiles", :class="{'--selected': selectedProfileIdMap[profile.id]}")
                td(v-for="date in timelineDates", :class="{'--current': isCurrentSemester(date)}")
                  milestone-cell.cell-content(
                    :profile="profile",
                    :person-milestones="milestonesForSemester(profile, date)",
                    :date="date",
                    @error="openModalByName('server-error')"
                    @modal="openModalByName('profile-milestones', { profile, tab: 'milestones' })")

  </template>

  <style>

  @import "../init/variables.css";

  :root {
    --cellMaxHeight: 62;
    --selectionBoxRatio: .5
  }

  .timeline {
    display: flex;
    flex-direction: column;
    flex-wrap: nowrap;
    height: 100%;

    & .tables {
      width: 100%;
    }

    & .names-table {
      & .selection-box {
        width: calc(var(--cellWidth)*var(--selectionBoxRatio))em;
        max-width: calc(var(--cellWidth)*var(--selectionBoxRatio))em;
        text-align: center;
        & input {
          width: auto;
        }
        & button {
          text-transform: none;
          padding: 0;
        }
        & select {
          width: 100%;
          font-size: .8em;
          border: none;
        }
      }
    }

    & .timeline-table {
      transform: translate(calc(var(--cellWidth)*(1+var(--selectionBoxRatio)))em, 0);
      width: calc(100% - var(--cellWidth)em);

      & th.--current, td.--current {
        background-color: color(var(--themeColor) alpha(20%));
      }
    }

    & .cell-content {
      cursor: pointer;
    }

    & .cell-content, .header-content {
      min-width: var(--cellWidth)em;
      max-width: var(--cellWidth)em;
      min-height: var(--cellMinHeight)px;
      max-height: var(--cellMaxHeight)px;

      & .person-position-label {
        font-size: .8em;
      }
    }

    & tr.--selected, & tr.--selected td {
      background-color: yellow;
    }

    & .header-content {
      height: 100px;
      overflow: hidden;
      max-height: 100%;
    }


    & .months-label {
      display: inline-block;
      font-size: .7em;
    }

  }

  </style>
