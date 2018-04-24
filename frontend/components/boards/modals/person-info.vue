<script>

import { mapGetters, mapActions } from "vuex"

import { SlideYUpTransition } from 'vue2-transitions'
import Modal from "../../shared/modal.vue"
import ApplicationInfoDisplay from "./person-info/application-info-display.vue"
import ApplicationInfoEdit from "./person-info/application-info-edit.vue"
import CommentsComponent from "./person-info/comments-component.vue"

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
      applicationForm: null,
      applicationError: false,
      editing: false,
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
    scrollTop() {
      this.$el.querySelector(".person-info").scrollTo({top: -10000, behavior: "smooth"})
    }
  },
  components: {
    Modal,
    SlideYUpTransition,
    ApplicationInfoDisplay,
    ApplicationInfoEdit,
    CommentsComponent,
  }
}
</script>

<template lang="pug">
  modal(@close="closeModal")
    template(slot="header")
      h1 Information on {{person.full_name}}
    template(slot="body")
      div(v-if="applicationError", style="text-align: center;")
        p There was an error while fetching this applicant's information.

      div.person-info(v-if="isLoaded")

        div.comments(v-if="true")
          comments-component(:application="application", @scroll="scrollTop")

        div(v-else)
          div.action-menu
            button.icon.pencil(type="button", @click="editing = !editing")
          slide-y-up-transition
            application-info-display(:application="application", :person="person", :application-form="applicationForm", v-if="!editing")
          slide-y-up-transition
            application-info-edit(:application="application", :person="person", :application-form="applicationForm" v-if="editing", @update="onUpdateApplication", @error="applicationError = true")


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
    padding-top: 0;

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
