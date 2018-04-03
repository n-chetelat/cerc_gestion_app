<script>

import PersonCard from "./person-card.vue"

export default {
  name: "Phase",
  props: {
    phase: {
      required: true
    }
  },
  computed: {
    description() {
      return this.phase.description  || "No description"
    }
  },
  methods: {
    openModal(modalName, data) {
      this.$emit('modal', modalName, data)
    }
  },
  components: {
    PersonCard
  }
}
</script>

<template lang="pug">
  div.phase
    h2.heading {{phase.title}}
      span.description(v-tooltip="description")
    div.stats
      p #[span.count {{phase.persons.length}}] people in this section
    person-card(v-for="person in phase.persons", :person="person", @modal="openModal")

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

  & .heading {
    font-size: 1.2em;
    padding: 0 5px;
  }

  & .heading .description {
    height: 1em;
    width: 1em;
    display: inline-block;
    background: url("../../static/icons/info.svg") center center / 100% no-repeat;
    float: right;
  }

  & .stats {
    font-size: .9em;
    margin-left: 1em;
    & .count {
      font-weight: bold;
    }
    & .count:before {
      content: "";
      background: url("../../static/icons/user-green.svg") center center / 100% no-repeat;
      width: 15px;
      height: 15px;
      display: inline-block;
      margin-right: 4px;
      margin-bottom: -1px;
    }
  }
}

</style>
