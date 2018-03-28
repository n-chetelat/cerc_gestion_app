<script>

import { mapGetters, mapActions } from "vuex"

import Modal from "../../shared/modal.vue"

import DisplayText from "../form-fields/display-text.vue"

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
      infoOpen: false,
      applicationOpen: false,
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
    Modal,
    DisplayText
  }
}
</script>

<template lang="pug">
  modal(@close="closeModal")
    template(slot="header")
      h1 {{person.full_name}}
    template(slot="body")
      div.person-info(v-if="isLoaded")

        div.info-section.person-info-profile(:class="{'--open': infoOpen}")
          h2.collapsable-header(@click="infoOpen = !infoOpen") Info
            span.arrow-icon
          div.collapsable-content(v-if="infoOpen")
            p {{person.email}}

        div.info-section.person-info-application(:class="{'--open': applicationOpen}")
          h2.collapsable-header(@click="applicationOpen = !applicationOpen") Application
            span.arrow-icon
          div.collapsable-content(v-if="applicationOpen")
            p For position: {{application.position}}
            p Starting on: {{application.starting_semester}}
            div.display-fields
              component(v-for="field in application.form_fields", :is="`display-text`", :field="field")

</template>

<style>

  .person-info {
    min-height: 300px;
    max-height: 500px;
    overflow: auto;

    & .collapsable-header {
      height: 32px;
      width: 50%;
      padding-bottom: 40px;
      border-bottom: 1px solid transparent;
      position: relative;

      &:hover {
        border-bottom: 1px solid black;
      }
    }
    & .arrow-icon {
      position: absolute;
      right: 0;
      display: inline-block;
      height: 32px;
      width: 32px;
      margin-left: 10px;
      margin-bottom: -3px;
      background: url("../../../static/icons/circle-down.svg") bottom left / 70% no-repeat;
    }
  }

  .--open {
    & .collapsable-header {
      border-bottom: 1px solid black;
    }
    & .arrow-icon {
      background: url("../../../static/icons/circle-up.svg") bottom left / 70% no-repeat;
    }
  }

</style>
