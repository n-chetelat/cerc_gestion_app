<script>

import { mapGetters, mapActions } from "vuex"

import Modal from "../modal.vue"

export default {
  name: "PersonInfo",
  props: {
    personId: {
      required: true
    }
  },
  data() {
    return {
    }
  },
  async created() {
    const payload = {person_id: this.personId, options: {scopes: ["application"]}}
    await this.fetchPerson(payload)
    if (this.currentPerson.application_id) {
      await this.fetchApplication(this.currentPerson.application_id)
    }
  },
  computed: {
    ...mapGetters("persons", ["currentPerson"]),
    ...mapGetters("application", ["currentApplication"]),
  },
  methods: {
    ...mapActions("persons", ["fetchPerson"]),
    ...mapActions("application", ["fetchApplication"]),
    closeModal() {
      this.$emit("close")
    }
  },
  components: {
    Modal
  }
}
</script>

<template lang="pug">
  modal(@close="closeModal")
    template(slot="body")
      div.person-info(v-if="currentPerson")
        div {{currentPerson}}
        div {{currentApplication}}

</template>

<style>

</style>
