<script>

import { mapActions } from "vuex"

import ModalMixin from "../../mixins/modal-mixin"

import PersonInfoModal from "../shared/modals/person-info.vue"

export default {
  name: "PersonCard",
  mixins: [ModalMixin],
  props: {
    person: {
      required: true
    }
  },
  methods: {
    ...mapActions("persons", ["setPerson"]),
  },
  components: {
    PersonInfoModal
  }
}
</script>

<template lang="pug">
  div.person-card
    person-info-modal(@close="closeModal", v-if="modalVisible && modalName === 'person-info'", :person="person")
    div.card-content(@click="openModal('person-info')")
      h3.card-title(@click="openModal('person-info')") {{person.full_name}}
      p {{person.email}}
      p Applying for: {{person.position}}
      p Starting on: {{person.starting_semester}}
      p Received on: {{person.applied_at}}

</template>

<style>

.person-card {
  padding: 10px;
  margin: 5px;
  background-color: yellow;

  & .card-title:hover {
    cursor: pointer;
    text-decoration: underline;
  }
}

</style>
