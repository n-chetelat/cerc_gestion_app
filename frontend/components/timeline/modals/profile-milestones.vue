<script>

import { mapGetters, mapActions } from "vuex"

import Modal from "components/shared/modal.vue"

import { values } from "lodash-es"

export default {
  name: "ProfileMilestones",
  props: {
    profile: { required: true },
  },
  data() {
    return {
    }
  },
  computed: {
    ...mapGetters("milestones", ["milestonesById", "milestonesByPersonId"]),
    ...mapGetters("dates", ["semesters", "months"]),
    ...mapGetters("positions", ["allPositionsById"]),
    ...mapGetters("profiles", ["fieldsById", "profileFieldValuesByProfileId"]),
  },
  methods: {
  },
  components: {
    Modal,
  }
}
</script>

<template lang="pug">
  modal(@close="$emit('close')")
    h1.profile-milestones-header(slot="header")
      span {{profile.full_name}}
    div.profile-milestones(slot="body")
      div.profile-info
        ul
          li(v-for="personField in profileFieldValuesByProfileId[profile.id]") {{fieldsById[personField.profile_field_id].label}}
            span Value: {{personField.value}}
      div.milestones
        ul
          li(v-for="personMilestone in milestonesByPersonId[profile.uuid]") {{milestonesById[personMilestone.positions_milestone_id].title}}
            span Date: {{personMilestone.date}}



</template>

<style>

  @import "../../../init/variables.css";

  .profile-milestones {

  }


</style>
