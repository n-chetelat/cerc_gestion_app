  <script>
  import { mapGetters } from "vuex"

import MilestoneCell from "components/timeline/milestone-cell.vue"

  export default {
    name: "TimelineTable",
    props: {
      displayedProfiles: { required: true },
      selectedProfileIds: { required: true },
      timelineDates: { required: true },
    },
    data() {
      return {

      }
    },
    computed: {
      ...mapGetters("milestones", ["milestonesBySemester"]),
      selectedProfileIdMap() {
        const profileIdMap = {}
        this.selectedProfileIds.forEach((id) => {
          profileIdMap[id] = id
        })
        return profileIdMap
      },
      currentDate() {
        const today = new Date
        const month = `${today.getMonth() + 1}`.padStart(2, "0")
        const date = `${today.getFullYear()}-${month}-01`
        return date
      },
    },
    methods: {
      isCurrentSemester(semester) {
        const dates = [semester.id, ...semester.months.map(m => m.id)]
        return dates.includes(this.currentDate)
      },
      milestonesForSemester(profile, semester) {
        if (!this.milestonesBySemester[profile.uuid]) return null
        return this.milestonesBySemester[profile.uuid][semester.id]
      },
      scrollHeaderSideways() {
        const body = this.$el.querySelector(".table-body")
        const head = this.$el.querySelector(".table-head")
        const leftEdge = body.getBoundingClientRect().x
        head.setAttribute("style", `left: ${leftEdge}px;`)
      },
      emitModalByName(name, data={}) {
        this.$emit("modal", name, data)
      },
      emitErrorModal(data) {
        this.emitModalByName('server-error', data)
      }
    },
    components: {
      MilestoneCell
    },
  }
  </script>

  <template lang="pug">
    div.table.timeline-table(@scroll="scrollHeaderSideways")

      div.table-head
        div.row
          div.cell(v-for="date in timelineDates", :class="{'--current': isCurrentSemester(date)}")
            div.date-label
              div {{date.label}}
              span.months-label {{date.months[0].label}} - {{date.months[date.months.length-1].label}}
      div.table-body
        div.row.placeholder-row
          div.cell(v-for="date in timelineDates")
        div.row(v-for="profile in displayedProfiles", :class="{'--selected': selectedProfileIdMap[profile.id]}")
          div.cell(v-for="date in timelineDates", :class="{'--current': isCurrentSemester(date)}")
            milestone-cell(
              :profile="profile",
              :person-milestones="milestonesForSemester(profile, date)",
              :date="date",
              @error="emitErrorModal",
              @modal="emitModalByName('profile-milestones', { profile, tab: 'milestones' })")



  </template>

  <style>

  @import "../../init/variables.css";

  .timeline-table {

    & .months-label {
      font-size: .7em;
    }

  }

  </style>
