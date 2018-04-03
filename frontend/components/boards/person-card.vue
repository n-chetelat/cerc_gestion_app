<script>

export default {
  name: "PersonCard",
  props: {
    person: {
      required: true
    }
  },
  methods: {
    openPersonInfoModal() {
      this.$emit("modal", "person-info", {person: this.person})
    },
    openCorrespondenceModal() {

    },
  },
}
</script>

<template lang="pug">
  div.person-card
    div.card-content
      h3.heading.link(@click="openPersonInfoModal", v-tooltip="`See person's information`") {{person.full_name}}
      p.icon-bg.email.link(@click="openCorrespondenceModal", v-tooltip="'See correspondence'") {{person.email}}
      p.icon-bg.position {{person.position}}
      p.icon-bg.semester {{person.starting_semester}}
      p.received Received on: {{person.applied_at}}

</template>

<style>

:root {
  --themeColor: #00a668aa;
}

.person-card {
  padding: 10px;
  margin: 5px;
  border-radius: 5px;
  background-color: var(--themeColor);
  box-shadow: 0 0 20px black;
  margin-bottom: 15px;

  & .card-content {
    font-size: .8em;

    & .heading {
      font-size: 1rem;
    }
    & .link:hover {
      cursor: pointer;
      text-decoration: underline;
    }

    & .icon-bg:before {
      content: "";
      width: 15px;
      height: 15px;
      display: inline-block;
      margin-right: 4px;
      margin-bottom: -1px;
    }

    & .email:before {
      background: url("../../static/icons/envelop.svg") center center / 100% no-repeat;
    }

    & .position:before {
      background: url("../../static/icons/library.svg") center center / 100% no-repeat;
    }

    & .semester:before {
      background: url("../../static/icons/calendar.svg") center center / 100% no-repeat;
    }

    & .received {
      font-size: .9em;
    }
  }
}

</style>
