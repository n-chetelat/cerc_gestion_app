<script>

import { mapGetters } from "vuex"

import DropBox from "./board-sidebar/drop-box.vue"

export default {
  name: "BoardSidebar",
  props: {
    user: {
      required: true
    },
    loggedIn: {
      default: () => { return [] }
    }
  },
  data() {
    return {
    }
  },
  computed: {
    ...mapGetters("boards", ["finalPhases"]),
  },
  methods: {
    openModal(modalName, data) {
      this.$emit('modal', modalName, data)
    },
    userInitials(user) {
      return user.name[0] + user.lastname[0]
    },
    userTooltip(user) {
      return `${user.name} ${user.lastname} (${user.email})`
    }
  },
  components: {
    DropBox
  }
}
</script>

<template lang="pug">
  div.board-sidebar
    div.heading
      span.circle.user-initials(v-tooltip="userTooltip(user)") {{userInitials(user)}}
      a.circle.admin-link(href="/admin", v-tooltip="'To admin dashboard'", target="_blank") ""
    div.logged-in(v-if="loggedIn.length")
      p.logged-in-label Now logged in:
      div
        span.circle.user_initials(v-for="loggedUser in loggedIn", v-tooltip="userTooltip(loggedUser)") {{userInitials(loggedUser)}}
    div.drop-boxes
      drop-box.box(v-for="phase in finalPhases", :phase="phase", @modal="openModal")

</template>

<style scoped>

:root {
  --themeColor: #00a668;
}

.board-sidebar {
  background-color: var(--themeColor);
  display: flex;
  overflow-y: auto;
  flex-direction: column;
  box-shadow: -2px 0px 6px;
  z-index: 4;
  & .heading {
    text-align: left;
    padding: 10px;
    display: flex;
    justify-content: flex-start;
    & * {
      margin: auto 3px;
    }

    & .admin-link {
      color: transparent;
      background: url("../../static/icons/key.svg") center center / 50% no-repeat white;
      &:hover {
        background-color: gray(90%);
      }
    }
  }

  & .logged-in {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    padding: 0 5px;
    & .logged-in-label {
      width: 100%;
      color: white;
      font-size: .8em;
      margin-right: 3px;
    }
    & .circle {
      margin: auto 3px;
      width: 40px;
      height: 40px;
      padding: 3px;
      background-color: #3e94e2;
      color: white;
      border: 3px solid white;
    }
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
    height: 80%;
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
  }
  & .box {
    width: 90%;
    margin: auto;
    height: 20%;
    max-height: 100px;
  }
}

</style>
