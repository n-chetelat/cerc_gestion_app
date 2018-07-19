<script>

import { mapGetters } from "vuex"

import AdminNav from "components/shared/admin-nav.vue"
import DropBox from "./board-sidebar/drop-box.vue"
import LoggedInUsers from "./board-sidebar/logged-in-users.vue"

export default {
  name: "BoardSidebar",
  props: {
    user: {
      required: true
    },
  },
  data() {
    return {
    }
  },
  computed: {
    ...mapGetters("boards", ["finalPhases"]),
    userInitials() {
      return this.user.name[0] + this.user.lastname[0]
    },
    userTooltip() {
      return `${this.user.name} ${this.user.lastname} (${this.user.email})`
    }
  },
  methods: {
    openModal(modalName, data) {
      this.$emit('modal', modalName, data)
    },
  },
  components: {
    AdminNav,
    DropBox,
    LoggedInUsers
  }
}
</script>

<template lang="pug">
  div.board-sidebar
    div.heading
      span.circle.user-initials(v-tooltip="userTooltip") {{userInitials}}
      admin-nav.admin-links
    logged-in-users.logged-in

    div.drop-boxes
      drop-box.box(v-for="phase in finalPhases", :phase="phase", @modal="openModal")

</template>

<style>

@import "../../init/variables.css";

.board-sidebar {
  background-color: var(--themeColor);
  display: flex;
  overflow-y: auto;
  flex-direction: column;
  justify-content: space-between;
  box-shadow: -2px 0px 6px;
  z-index: 4;
  & .heading {
    text-align: left;
    padding: 10px;
    display: flex;
    justify-content: space-between;
    & * {
      margin: auto 3px;
    }

    & .admin-links {
      display: flex;
      flex-wrap: wrap;
      color: white;
      font-size: .8em;
      text-decoration: underline;
      & .admin-link {
        display: inline-block;
        padding: 5px;
        &:before {
          content: none;
        }
      }
      & select.admin-link {
        width: 90%;
        margin-left: 0;
        padding: 0;
      }
    }
  }
  & .logged-in {
    height: 40%;
  }

  & .circle {
    font-weight: bold;
    display: inline-block;
    background-color: white;
    color: var(--themeColor);
    padding: 10px;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    line-height: 2em;
    text-align: center;
  }

  & .user-initials {
    text-transform: uppercase;
  }

  & .drop-boxes {
    height: 50%;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
  }
  & .box {
    width: 90%;
    margin: auto;
    min-height: 100px;
    margin-bottom: 1em;
  }
}

</style>
