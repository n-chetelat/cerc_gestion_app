<script>

import { mapGetters, mapActions } from "vuex"

import { CollapseTransition, SlideYUpTransition } from 'vue2-transitions'
import Modal from "../../shared/modal.vue"
import ApplicationInfoDisplay from "./person-info/application-info-display.vue"
import ApplicationInfoEdit from "./person-info/application-info-edit.vue"

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
      applicationNotFound: false,
      editing: false,
    }
  },
  async created() {
    if (this.person.application_id) {
      await this.fetchApplication(this.person.application_id).then(({data}) => {
        this.application = data
      }).catch((error) => {
        this.applicationNotFound = true
      })
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
    CollapseTransition,
    SlideYUpTransition,
    ApplicationInfoDisplay,
    ApplicationInfoEdit,
  }
}
</script>

<template lang="pug">
  modal(@close="closeModal")
    template(slot="header")
      h1 Information on {{person.full_name}}
    template(slot="body")
      div(v-if="applicationNotFound", style="text-align: center;")
        p There was an error while fetching this applicant's information.
        p Please try again later.

      div.person-info(v-if="isLoaded")
        div.info-section.person-info-profile(:class="{'--open': infoOpen}")
          h2.collapsable-header(@click="infoOpen = !infoOpen") General
            span.icon.arrow-icon
          collapse-transition
            div.collapsable-content(v-if="infoOpen")
              div.field-row
                label Name
                span {{person.name}}
              div.field-row
                label Lastname
                span {{person.lastname}}
              div.field-row
                label Email
                span {{person.email}}

        div.info-section.person-info-application(:class="{'--open': applicationOpen}")
          h2.collapsable-header(@click="applicationOpen = !applicationOpen") Application
            span.icon.arrow-icon
          collapse-transition
            div.collapsable-content(v-if="applicationOpen")
              button.icon.pencil(type="button", @click="editing = !editing")
              slide-y-up-transition
                application-info-display(:application="application", :key="'display'", v-if="!editing")
              slide-y-up-transition
                application-info-edit(:application="application", :key="'edit'", v-if="editing")


</template>

<style>

  :root {
    --themeColor: #00a668;
    --windowHeight: 400;
  }

  .person-info {
    min-height: 300px;
    max-height: var(--windowHeight)px;
    overflow: auto;
    padding: 2em 2em;

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
    & .collapsable-content {
      padding-bottom: 30px;
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
    & .pencil {
      background: url("../../../static/icons/pencil.svg") bottom left / 70% no-repeat;
    }
    & .field-row {
      padding: .5em;
      padding-top: 0;
      margin: .5em;

      & label {
        background-color: gray(200);
        border-radius: 3px;
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
    &.--open {
      & .collapsable-header {
        border-bottom: 1px solid black;
      }
      & .arrow-icon {
        background: url("../../../static/icons/circle-up.svg") bottom left / 70% no-repeat;
      }
    }

  }

</style>
