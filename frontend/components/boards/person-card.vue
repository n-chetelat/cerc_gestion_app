<script>

import { mapActions } from "vuex"

export default {
  name: "PersonCard",
  props: {
    person: {
      required: true
    }
  },
  methods: {
    ...mapActions("persons", ["setPerson"]),
    ...mapActions("modals", ["openModal"]),
    showPersonInfo() {
      this.setPerson(this.person)
      this.openModal("person-info")
    }
  }
}
</script>

<template lang="pug">
  div.person-card
    h3 {{person.full_name}}
    p {{person.email}}
    p Applying for: {{person.position}}
    p Starting on: {{person.starting_semester}}
    p Received on: {{person.applied_at}}
    button(type="button", @click="showPersonInfo") More...

</template>

<style>

.person-card {
  padding: 10px;
  margin: 5px;
  background-color: yellow;
}

</style>
