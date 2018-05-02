<script>

import { mapGetters, mapActions } from "vuex"

import { sendStatusMessage } from "cable/board"

import { SlideYUpTransition } from 'vue2-transitions'
import Modal from "../../shared/modal.vue"
import ApplicationInfoDisplay from "./person-info/application-info-display.vue"
import ApplicationInfoEdit from "./person-info/application-info-edit.vue"
import CommentsComponent from "./person-info/comments-component.vue"
import Correspondence from "./person-info/correspondence.vue"

export default {
  name: "PersonInfo",
  props: {
    person: {
      required: true
    },
    tab: {},
  },
  data() {
    return {
      application: null,
      applicationForm: null,
      applicationError: false,
      editing: false,
      currentTab: this.tab || "information",
      tabs: ["information", "comments", "email"],
      emailSection: (this.tab === "email") ? "new" : null,
    }
  },
  async created() {
    await this.getApplication()
    await this.getPositionForm(this.application.position_id)
    await this.getAllPositions()
    this.applicationForm = this.positionFormsById[this.application.position_id]
  },
  computed: {
    ...mapGetters("positions", ["allPositions", "positionFormsById"]),
    ...mapGetters("boards", ["phasesById"]),
    isLoaded() {
      return !!(this.person && this.application && this.applicationForm)
    }
  },
  methods: {
    ...mapActions("application", ["fetchApplication"]),
    ...mapActions("positions", ["getAllPositions", "getPositionForm"]),
    closeModal() {
      this.$emit("close")
    },
    getApplication() {
      if (this.person.application_id) {
        return this.fetchApplication(this.person.application_id).then(({data}) => {
          this.application = data
        }).catch((error) => {
          this.applicationError = true
        })
      }
    },
    async onUpdateApplication(data) {
      await this.getApplication()
      this.editing = false
    },
    broadcastNewComment() {
      const params = {applicant: this.person.full_name, phase: this.phasesById[this.person.phase_id].title}
      sendStatusMessage("comment", params)
    }
  },
  components: {
    Modal,
    SlideYUpTransition,
    ApplicationInfoDisplay,
    ApplicationInfoEdit,
    CommentsComponent,
    Correspondence,
  }
}
</script>

<template lang="pug">
  modal(@close="closeModal")
    template(slot="header")
      h1 {{person.full_name}}
    template(slot="body")
      div(v-if="applicationError", style="text-align: center;")
        p There was an error while fetching this applicant's information.

      div.person-info(v-if="isLoaded")

        ul.nav-tabs
          li.nav-tab(v-for="tab in tabs", @click="currentTab = tab", :class="{'--selected': currentTab === tab}") {{tab | capitalize}}

        div(v-show="currentTab === 'information'")
          div.action-menu
            button.icon.pencil(type="button", @click="editing = !editing", v-tooltip="'Edit application information'")
          slide-y-up-transition
            application-info-display(:application="application", :person="person", :application-form="applicationForm", v-if="!editing")
          slide-y-up-transition
            application-info-edit(:application="application", :person="person", :application-form="applicationForm" v-if="editing", @update="onUpdateApplication", @error="applicationError = true")

        div.comments(v-show="currentTab === 'comments'")
          slide-y-up-transition
            comments-component(:application="application", @comment="broadcastNewComment")

        div.correspondence(v-show="currentTab === 'email'")
          slide-y-up-transition
            correspondence(:person="person", :section="emailSection")

</template>

<style>

  :root {
    --themeColor: #00a668;
    --windowHeight: 400;
    --navColor: #4490ce;
  }

  .person-info {
    min-height: 300px;
    max-height: var(--windowHeight)px;
    overflow: auto;
    padding: 2em 2em;
    padding-top: 0;

    & .nav-tab {
      cursor: pointer;
      display: inline-block;
      padding: 5px;
      margin: auto 2px;
      background-color: color(var(--navColor) alpha(50%));
      border-radius: 2px 2px 0 0;
      border-bottom: 2px solid transparent;
      font-weight: bold;
      transition: background-color .5s ease;
      &.--selected {
        background-color: var(--navColor);
        padding-top: 7px;
        border-bottom: 2px solid black;
      }
    }

    & .action-menu {
      width: 100%;
      height: 32px;
    }

    & .icon {
      height: 32px;
      width: 32px;
      display: inline-block;
      margin-bottom: -3px;
    }
    & .pencil {
      background: url("../../../static/icons/pencil-charcoal.svg") bottom left / 90% no-repeat;
      float: right;
      &:hover {
        background: url("../../../static/icons/pencil.svg") bottom left / 100% no-repeat;
      }
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
      & ul.file-list {
        display: block;
        margin: auto;
      }
      & .pdf-icon {
        background: url("../../../static/icons/file-pdf.svg") left bottom / 70% no-repeat;
      }
    }

  }

</style>
