<script>

import { mapGetters, mapActions } from "vuex"

import Modal from "../modal.vue"

export default {
  name: "PersonInfo",
  props: {
    person: {
      required: true
    }
  },
  data() {
    return {
      application: null,
    }
  },
  async created() {
    if (this.person.application_id) {
      this.application = await this.fetchApplication(this.person.application_id)
    }
  },
  computed: {
    isLoaded() {
      return this.person && this.application
    }
  },
  methods: {
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
      div.person-info(v-if="isLoaded")
        div {{person}}
        div {{application}}

</template>

<style>

  .person-info {

  }

</style>
