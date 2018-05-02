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
    p.logged-in-label Now logged in:
    div.logged-in-circles
      span.circle.user_initials(v-for="loggedUser in loggedInUsers", v-tooltip="userTooltip(loggedUser)") {{userInitials(loggedUser)}}
    div.logged-in-actions
      p.logged-in-message(v-for="message in loggedInMessages") {{message.content}}
        span.date {{formattedDateTime(message.timestamp)}}
      p.logged-in-message This user has done this thing just now.
        span.date Jan 43, 2039
      p.logged-in-message This user has done this thing just now.
        span.date Jan 43, 2039

</template>

<style>

:root {
  --themeColor: #00a668;
  --textFamily: 'Open Sans', Arial, sans-serif;
  --textColor: gray(20);
}

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
    min-height: 50%;
    margin: 1em auto;
    border-radius: 3px;
    padding: 5px;
    background-color: gray(90%);
    display: flex;
    flex-direction: column;
    overflow: auto;
  }
  & .logged-in-message {
    background-color: white;
    font-size: .8em;
    font-family: var(--textFamily);
    color: var(--textColor);
    margin: 0;
    margin-bottom: 4px;
    padding: 3px;
    border-left: 2px solid gray;
    & .date {
      margin-left: 4px;
      color: gray(65%);
      font-size: .9em;
    }
  }
}

</style>
