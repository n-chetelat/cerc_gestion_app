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
    }
  },
}
</script>

<template lang="pug">
  div.person-card
    div.card-content(@click="openPersonInfoModal")
      h3.card-title(@click="openPersonInfoModal") {{person.full_name}}
      p {{person.email}}
      p Applying for: {{person.position}}
      p Starting on: {{person.starting_semester}}
      p Received on: {{person.applied_at}}

</template>

<style>

.person-card {
  padding: 10px;
  margin: 5px;
  background-color: yellow;

  & .card-title:hover {
    cursor: pointer;
    text-decoration: underline;
  }
}

</style>
