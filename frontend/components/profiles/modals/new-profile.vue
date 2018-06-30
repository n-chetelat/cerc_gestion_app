<script>

import { mapGetters, mapActions } from "vuex"

import Modal from "components/shared/modal.vue"

import { values } from "lodash-es"

export default {
  name: "NewProfile",
  data() {
    return {
      newProfile: {
        name: null, lastname: null, email: null,
        position_id: null, starting_date: null
      }
    }
  },
  computed: {
    ...mapGetters("positions", ["allPositions", "allPositionsById"]),
    ...mapGetters("dates", ["semesters", "months"]),
    dateCollection() {
      const positionId = this.newProfile.position_id
      if (!positionId) return []
      else if (this.allPositionsById[positionId].time_interval === "semester") {
        return this.semesters
      } else if (this.allPositionsById[positionId].time_interval === "month") {
        return this.months
      } else return []
    },
    formIsValid() {
      const noFieldIsNull = values(this.newProfile).every(val => (val !== null))
      const noFieldEmpty = values(this.newProfile).filter(p => typeof p === "string").every(val => val.length)
      const emailValid = !!(this.newProfile.email && this.newProfile.email.match(/\w[\w.-]+@[\w.-]+\.[\w.-]+\w$/))
      const positionValid = this.allPositions.map(p => p.id).includes(this.newProfile.position_id)
      const dateValid = this.dateCollection.map(d => d.id).includes(this.newProfile.starting_date)
      return noFieldIsNull && noFieldEmpty && emailValid && positionValid && dateValid
    },
  },
  methods: {
    ...mapActions("profiles", ["createProfile"]),
    async saveNewProfile() {
      if (this.formIsValid) {
        try {
          await this.createProfile(this.newProfile)
        } catch(err) {
          this.$emit("error")
        }
      } else {
        return
      }
    },
  },
  components: {
    Modal
  }
}
</script>

<template lang="pug">
  modal(@close="$emit('close')")
    h1(slot="header")
      span Create New Profile

    div.new-profile(slot="body")
      span.form-line
        label Name
        input(type="text", v-model="newProfile.name")
      span.form-line
        label Lastname
        input(type="text", v-model="newProfile.lastname")
      span.form-line
        label Email
        input(type="text", v-model="newProfile.email")

      span.form-line
        label Position
        select(v-model="newProfile.position_id")
          option(v-for="position in allPositions", :value="position.id") {{position.title}}

      span.form-line
        label Starting Date
        select(v-model="newProfile.starting_date", :disabled="!newProfile.position_id")
          option(v-for="date in dateCollection", :value="date.id") {{date.label}}

      button.submit(type="button", @click="saveNewProfile", :class="{'--disabled': !formIsValid}") Save

</template>

<style>

  .new-profile {
    padding: 10px;
    padding-bottom: 20px;

    & .form-line {
      display: flex;
      margin-bottom: 1em;

      & label {
        width: 20%;
        text-align: right;
        padding-right: 1em;
      }
      & input, select {
        width: 70%;
      }
    }
  }

</style>
