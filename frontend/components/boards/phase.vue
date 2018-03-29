<script>

import PersonCard from "./person-card.vue"

export default {
  name: "Phase",
  props: {
    phase: {
      required: true
    }
  },
  methods: {
  },
  components: {
    PersonCard
  }
}
</script>

<template lang="pug">
  div.phase
    h2 {{phase.title}}
    person-card(v-for="person in phase.persons", :person="person")

</template>

<style>

.phase {

  border-radius: 2px;
  width: 300px;
  height: 500px;
  overflow-y: auto;
  overflow-x: hidden;
  margin: 1em;
  padding: .5em;
  box-shadow: 2px 2px 15px 1px;
}

</style>
