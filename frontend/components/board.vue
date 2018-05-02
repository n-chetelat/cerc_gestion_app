  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { mapGetters, mapActions } from "vuex"
import { find, filter } from "lodash-es"

import { sendStatusMessage, getParticipantInfo, setCallback } from "cable/board"


import Phase from "./boards/phase.vue"
import PersonInfoModal from "./boards/modals/person-info.vue"
import BoardSidebar from "./boards/board-sidebar.vue"

  export default {
    name: "Board",
    mixins: [SceneMixin, ModalMixin],
    props: {
      boardSlug: {
        required: true
      }
    },
    beforeCreate() {
      setCallback((data) => {
        if (!this.currentUser) return
        if (data.users) {
          this.setLoggedInUsers(data.users)
        } else if (data.message) {
          this.addStatusMessage(data.message)
        }
      })
    },
    async created() {
      await this.fetchBoard(this.boardSlug)
      await this.fetchUserInfo()
      getParticipantInfo()
    },
    data() {
      return {
        person: null,
        tab: null,
      }
    },
    computed: {
      ...mapGetters("users", ["currentUser"]),
      ...mapGetters("boards", ["currentBoard", "nonFinalPhases"]),
      isLoaded() {
        return !!(this.loaded && this.currentBoard)
      },
    },
    methods: {
      ...mapActions("users", ["fetchUserInfo", "addStatusMessage", "setLoggedInUsers"]),
      ...mapActions("boards", ["fetchBoard"]),
      openModalByName(modalName, data) {
        if (modalName === "person-info") {
          this.person = data.person
          this.tab = data.tab
        }
        this.openModal(modalName)
      },
      broadcastStatusMessage(type) {
        sendStatusMessage(type)
      }
    },
    components: {
      Phase,
      PersonInfoModal,
      BoardSidebar
    }
  }
  </script>

  <template lang="pug">
    div.boards(v-if="isLoaded")
      person-info-modal(@close="closeModal", v-if="modalVisible && modalName === 'person-info'", :person="person", :tab="tab")

      div.phases-wrapper
        div.phases(:style="{width: (nonFinalPhases.length * 320) + 'px'}")
          phase(v-for="phase in nonFinalPhases", :phase="phase", @modal="openModalByName")
      board-sidebar.sidebar(v-if="currentUser", @modal="openModalByName", :user="currentUser")


  </template>

  <style>

  body {
    overflow-x: hidden;
  }

  .boards {
    display: flex;
    justify-content: space-between;
    height: 100%;
    width: 100%;
  }

  .phases-wrapper {
    overflow-x: auto;
    overflow-y: auto;
    padding: 1em;
    height: 100%;
  }

  .phases {
    display: flex;
    flex-wrap: nowrap;
    transition: transform 1s;
    height: 100%;
    overflow-y: auto;
  }

  .phase {
    height: 95%;
  }

  .sidebar {
    width: 350px;
  }

  </style>
