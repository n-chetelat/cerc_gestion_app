<script>
import { mapActions } from "vuex"

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
    },
  },
  methods: {
    ...mapActions("boards", ["changePersonPhase"]),
    openModal(modalName, data) {
      this.$emit('modal', modalName, data)
    },
    onDragOver(event) {
      event.dataTransfer.dropEffect = "move"
    },
    onDrop(event) {
      event.dataTransfer.dropEffect = "move"
      const [personId, oldPhaseId] = event.dataTransfer.getData("text")
        .split(",").map((id) => parseInt(id))
      const payload = {phaseId: this.phase.id, personId, oldPhaseId}
      this.changePersonPhase(payload)
    },
  },
  components: {
    PersonCard
  }
}
</script>

<template lang="pug">
  div.phase(@dragover.prevent="onDragOver", @drop.prevent="onDrop")
    h2.heading {{phase.title}}
      span.description(v-tooltip="description")
    span.email_label(v-tooltip="'Gmail tag label'") {{phase.email_label}}  &#8728;
    div.stats
      p #[span.count {{phase.persons.length}}] people in this section
    person-card(v-for="person in phase.persons", :key="person.id", :person="person", @modal="openModal")

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

  & .email_label {
    font-size: .7em;
    color: gray(60%);
    background-color: beige;
    padding: 2px 5px;
    padding-right: 5px;
    border: 1px solid gray(80%);
    border-radius: 10px 40px 40px 10px;
    margin-left: 1em;
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
