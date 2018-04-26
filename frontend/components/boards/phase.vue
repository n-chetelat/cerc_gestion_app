<script>
import { mapGetters, mapActions } from "vuex"

import { find } from "lodash-es"

import PersonCard from "./person-card.vue"

export default {
  name: "Phase",
  props: {
    phase: {
      required: true
    }
  },
  data() {
    return {
      beingDraggedOver: false
    }
  },
  computed: {
    ...mapGetters("boards", ["currentBoard"]),
    description() {
      return this.phase.description  || "No description"
    },
  },
  methods: {
    ...mapActions("boards", ["changePersonPhase", "fetchPhaseEmailTemplate"]),
    openModal(modalName, data) {
      this.$emit('modal', modalName, data)
    },
    onDragOver(event) {
      this.beingDraggedOver = true
      event.dataTransfer.dropEffect = "move"
    },
    onDrop(event) {
      this.beingDraggedOver = false
      event.dataTransfer.dropEffect = "move"
      const [personId, oldPhaseId] = event.dataTransfer.getData("text")
        .split(",")
      if (oldPhaseId === this.phase.uuid) return false
      const payload = {phaseId: this.phase.uuid, personId, oldPhaseId}
      this.changePersonPhase(payload).then(() => {
        if (this.phase.has_callback) {
          this.showEmailModal(personId)
        }
      })
    },
    showEmailModal(personId) {
      const person = find(this.phase.persons, (p) => p.uuid === personId)
      this.openModal("person-info", { person, tab: "email"})
    }
  },
  components: {
    PersonCard
  }
}
</script>

<template lang="pug">
  div.phase
    h2.heading
      span.title {{phase.title}}
      br
      span.email-label(v-if="phase.email_label", v-tooltip="'Gmail tag label'") {{phase.email_label}}  &#8728;
      span.email-label.no-label(v-else) No email label
      span.description(v-tooltip="description")
    div.stats
      p #[span.count {{phase.persons.length}}] {{phase.persons.length | pluralize('person', 'people')}} in this section
    div.drop-card(
      v-tooltip="`Drop person here to add to '${phase.title}'`",
      @dragover.prevent="onDragOver",
      @dragend.prevent="beingDraggedOver = false",
      @dragleave.prevent="beingDraggedOver = false",
      @drop.prevent="onDrop"
      :class="{'--expanded': beingDraggedOver}")
    person-card.person-card(v-for="person in phase.persons", :key="person.uuid", :person="person", @modal="openModal")
</template>

<style>

:root {
  --themeColor: #00a668;
}

.phase {

  border-radius: 2px;
  width: 300px;
  height: 500px;
  overflow: auto;
  margin: 1em;
  padding: .5em;
  box-shadow: -2px 2px 6px;

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

  & .email-label {
    font-size: .7em;
    color: gray(60%);
    background-color: beige;
    padding: 2px 5px;
    padding-right: 5px;
    border: 1px solid gray(80%);
    border-radius: 10px 40px 40px 10px;
    display: inline-block;
    &.no-label {
      background-color: rgb(191, 233, 217);
      border-radius: 2px;
    }
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

  & .drop-card {
    height: 1em;
    padding: 1em;
    margin: 1em auto;
    opacity: .3;
    border: 3px dashed var(--themeColor);
    transition-property: opacity, height;
    background: url("../../static/icons/plus-green.svg") center center / 5% no-repeat;
    transition-duration: .2s;
    transition-timing-function: ease;

    &.--expanded {
      height: 6em;
      opacity: 1;
    }
  }
}

</style>
