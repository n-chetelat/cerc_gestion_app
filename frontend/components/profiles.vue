  <script>
import SceneMixin from "mixins/scene-mixin.js"
import ModalMixin from "mixins/modal-mixin.js"

import { mapGetters, mapActions } from "vuex"

  export default {
    name: "Profiles",
    mixins: [SceneMixin, ModalMixin],
    async created() {
      try {
        await this.fetchProfileFields()
        await this.fetchProfiles()
      } catch (err) {
        this.openModal("server-error", {})
      }
    },
    data() {
      return {
      }
    },
    computed: {
      ...mapGetters("profiles", ["profiles", "fields"]),
    },
    methods: {
      ...mapActions("profiles", ["fetchProfiles", "fetchProfileFields"]),
      openModalByName(modalName, data) {
        this.openModal(modalName)
      },
    },
    components: {
    }
  }
  </script>

  <template lang="pug">
    div.profiles

      ul
        li(v-for="profile in profiles") {{profile.full_name}}
      hr
      ul
        li(v-for="field in fields") {{field.label}}


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
