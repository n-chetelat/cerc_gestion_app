<script>

import { mapGetters, mapActions } from "vuex"

import Modal from "components/shared/modal.vue"
import Field from "components/profiles/field.vue"

import { values } from "lodash-es"

export default {
  name: "ProfileMilestones",
  props: {
    profile: { required: true },
  },
  data() {
    return {
      currentTab: "information",
      tabs: ["information", "milestones"],
      newMilestone: {
        person_id: this.profile.id,
        positions_milestone_id: null,
        date: null
      }
    }
  },
  computed: {
    ...mapGetters("milestones", ["milestonesById", "milestonesByPosition", "milestonesByPersonId"]),
    ...mapGetters("dates", ["semesters", "months"]),
    ...mapGetters("positions", ["allPositionsById"]),
    ...mapGetters("profiles", ["fieldsById", "profileFieldValuesByProfileId"]),
    positionDates() {
      const position = this.allPositionsById[this.profile.position_id]
      if (position.time_interval === "semester") {
        return this.semesters
      } else if (position.time_interval === "month") {
        return this.months
      } else return []
    }
  },
  methods: {
    ...mapActions("milestones", ["createPersonMilestone", "updatePersonMilestone"]),
    async createNewMilestone() {
      await this.createPersonMilestone(this.newMilestone)
    }
  },
  components: {
    Modal,
    Field,
  }
}
</script>

<template lang="pug">
  modal(@close="$emit('close')")
    h1.profile-milestones-header(slot="header")
      span {{profile.full_name}}
    div.profile-milestones(slot="body")

      ul.nav-tabs
        li.nav-tab(v-for="tab in tabs", @click="currentTab = tab", :class="{'--selected': currentTab === tab}") {{tab | capitalize}}

      div.tab-section.profile-info(v-if="currentTab === 'information'")
        ul
          li.field-row(v-for="personField in profileFieldValuesByProfileId[profile.id]", v-if="personField && personField.value")
              span.field-label {{fieldsById[personField.profile_field_id].label}} &nbsp;
              field.field(:profile="profile", :field="fieldsById[personField.profile_field_id]")
      div.tab-section.milestones(v-if="currentTab === 'milestones'")
        ul
          li(v-for="personMilestone in milestonesByPersonId[profile.uuid]") {{milestonesById[personMilestone.positions_milestone_id].title}}
            span Date: {{personMilestone.date}}
          div(v-if="milestonesByPosition[profile.position_id] && milestonesByPosition[profile.position_id].length")
            select(v-model="newMilestone.positions_milestone_id")
              option(v-for="milestone in milestonesByPosition[profile.position_id]", :value="milestone.id") {{milestone.title}}
            select(v-model="newMilestone.date")
              option(v-for="date in positionDates", :value="date.id") {{date.label}}
            button(type="button", @click="createNewMilestone") save
          div(v-else)
            p There are no milestones for this person's position

</template>

<style>

  @import "../../../init/variables.css";

  .profile-milestones {

    & .nav-tabs {
      padding: 0 1em;
    }

    & .tab-section {
      padding: 1em;
      height: 90%;
      max-height: var(--windowHeight)px;
      overflow-y: auto;
    }

    & .field-row {
      display: flex;
      flex-wrap: nowrap;
      margin: .5em 0;
      & .field-label {
        width: 25%;
        display: flex;
        justify-content: center;
        justify-content: flex-end;
        padding: .5em;
      }
      & .field {
        width: 50%;
      }
    }

    & .profile-info {

    }

  }


</style>
