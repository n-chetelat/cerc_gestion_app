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

  border: 3px solid black;
  width: 30%;
  height: 600px;
  overflow-y: auto;
  overflow-x: hidden;
  float: left;

}

</style>
