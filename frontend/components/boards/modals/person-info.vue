<script>

import { mapGetters, mapActions } from "vuex"

import Modal from "../../shared/modal.vue"

import DisplayText from "../form-fields/display-text.vue"
import DisplayTextarea from "../form-fields/display-textarea.vue"
import DisplayDate from "../form-fields/display-date.vue"
import DisplayRadio from "../form-fields/display-radio.vue"
import DisplaySelect from "../form-fields/display-select.vue"
import DisplayCheckbox from "../form-fields/display-checkbox.vue"
import DisplayUploadSingle from "../form-fields/display-upload-single.vue"
import DisplayUploadMultiple from "../form-fields/display-upload-multiple.vue"

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
    DisplayText,
    DisplayDate,
    DisplayRadio,
    DisplaySelect,
    DisplayTextarea,
    DisplayCheckbox,
    DisplayUploadSingle,
    DisplayUploadMultiple
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
            span.icon.arrow-icon
          div.collapsable-content(v-if="infoOpen")
            div.field-row
              label Email
              span {{person.email}}

        div.info-section.person-info-application(:class="{'--open': applicationOpen}")
          h2.collapsable-header(@click="applicationOpen = !applicationOpen") Application
            span.icon.arrow-icon
          div.collapsable-content(v-if="applicationOpen")
            div.field-row
              label For position
              span {{application.position}}
            div.field-row
              label Starting on
              span {{application.starting_semester}}
            div.display-fields
              component.field-row(v-for="field in application.form_fields", :is="`display-${field.type}`", :field="field")

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
    & .icon {
      height: 25px;
      width: 25px;
      display: inline-block;
      margin-bottom: -3px;
    }
    & .arrow-icon {
      position: absolute;
      right: 0;
      height: 30px;
      width: 30px;
      background: url("../../../static/icons/circle-down.svg") bottom left / 70% no-repeat;
    }
    & .field-row {
      padding: .5em;
      padding-top: 0;
      margin: .5em;

      & label {
        background-color: black;
        color: white;
        display: inline-block;
        vertical-align: top;
        font-weight: bold;
        margin-right: 2em;
        width: 12em;
        padding: 2px 0;
        padding-right: .5em;
        text-align: right;
      }
      & ul {
        display: inline-block;
        list-style: none;
        padding: 0;
        margin: 0;
      }
      & .pdf-icon {
        background: url("../../../static/icons/file-pdf.svg") left bottom / 70% no-repeat;
      }
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
