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
    await this.fetchPerson(this.personId)
    if (this.currentPerson.application) {
      await this.fetchApplication(this.currentPerson.application.id)
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
