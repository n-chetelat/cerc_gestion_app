<script>

import { mapGetters, mapActions } from "vuex"

import DatesMixin from "../../../mixins/dates-mixin"

export default {
  name: "LoggedInUsers",
  mixins: [DatesMixin],
  props: {
  },
  data() {
    return {

    }
  },
  computed: {
    ...mapGetters("users", ["loggedInUsers", "loggedInMessages"]),
  },
  methods: {
    userInitials(user) {
      return user.name[0] + user.lastname[0]
    },
    userTooltip(user) {
      return `${user.name} ${user.lastname} (${user.email})`
    }
  },
}
</script>

<template lang="pug">
  div.logged-in-users
    p.logged-in-label Who else is logged in:
      span(v-if="!loggedInUsers.length") &nbsp; nobody
    div.logged-in-circles
      span.circle.user_initials(v-for="loggedUser in loggedInUsers", v-tooltip="userTooltip(loggedUser)") {{userInitials(loggedUser)}}
    div.logged-in-actions
      div(v-if="loggedInMessages.length")
        p.logged-in-message(v-for="message in loggedInMessages") {{message.content}}
          span.date {{formattedDateTime(message.timestamp)}}
      div.no-actions(v-else)
        p There is no recent activity from other administrators.

</template>

<style>

@import "../../../init/variables.css";

.logged-in-users {
  padding: 0 5px;
  display: flex;
  flex-direction: column;

  & .logged-in-label {
    color: white;
    font-size: .8em;
    margin-right: 3px;
  }

  & .logged-in-circles {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
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
  & .logged-in-actions {
    width: 100%;
    min-height: 50%;
    max-height: 50%;
    margin: 1em auto;
    border-radius: 3px;
    padding: 5px;
    background-color: gray(90%);
    display: flex;
    flex-direction: column;
    overflow: auto;
    font-family: var(--textFamily);
    color: var(--textColor);
  }
  & .no-actions {
    text-align: center;
  }
  & .logged-in-message {
    background-color: white;
    font-size: .8em;
    margin: 0;
    margin-bottom: 4px;
    padding: 3px;
    border-left: 5px solid gray;
    & .date {
      margin-left: 4px;
      color: gray(65%);
      font-size: .9em;
    }
  }
  & .logged-in-message:first-of-type {
    border-left: 5px solid #34e0a0;
  }
}

</style>
