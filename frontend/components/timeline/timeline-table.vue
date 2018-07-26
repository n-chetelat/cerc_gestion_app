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
    },
    components: {
      MilestoneCell
    },
  }
  </script>

  <template lang="pug">
    div.timeline-table(@scroll="scrollHeaderSideways")

      div.table-head
        div.row
          div.cell(v-for="date in timelineDates", :class="{'--current': isCurrentSemester(date)}")
            div.date-label
              p {{date.label}}
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
              @error="emitModalByName('server-error')",
              @modal="emitModalByName('profile-milestones', { profile, tab: 'milestones' })")



  </template>

  <style>

  @import "../../init/variables.css";

  :root {
    --cellHeight: 55;
  }

  .timeline-table {

    & .table-head {
      width: 100%;
      position: fixed;
      min-height: var(--cellMinHeight)px;
      margin: 0 auto;
      text-align: center;
      background-color: white;
      .cell {
        font-weight: bold;
        background-color: white;
      }
    }

    & .row {
      display: flex;
      &.--selected, &--selected .cell, &.--selected .name-cell {
        background-color: var(--highlightColor);
      }
      &.placeholder-row {
        background-color: white;
      }
    }

    & .cell {
      min-width: var(--cellWidth)em;
      width: var(--cellWidth)em;
      height: var(--cellHeight)px;
      border: 0.5px solid;
      display: flex;
      align-items: center;
      justify-content: center;
      &.--current {
        background-color: color(var(--themeColor) alpha(20%));
      }
    }

    & .months-label {
      display: inline-block;
      font-size: .7em;
    }

    & .date-label {
      & p {
        margin: 0;
      }
    }

  }

  </style>
