<script>

import { mapGetters, mapActions } from "vuex"

import FilterComponent from "components/shared/filter-component.vue"

export default {
  name: "AdminNav",
  data() {
    return {
      routes: [
        "timeline",
        "profiles"
      ],
      boardSlug: null
    }
  },
  async created() {
    if (!this.boards.length) {
      await this.fetchAllBoards()
    }
  },
  computed: {
    ...mapGetters("boards", ["boards"]),
    ...mapGetters("profiles", ["profiles"]),
  },
  methods: {
    ...mapActions("boards", ["fetchAllBoards"]),
    navigateToBoard() {
      if (!this.boardSlug) return
      this.$router.push({name: "board", params: { boardSlug: this.boardSlug }})
    },
    emitFilteredProfiles(profileIds, filtering) {
      this.$emit("filter", profileIds.map((id) => parseInt(id)), filtering)
    }
  },
  components: {
    FilterComponent
  },
  watch: {
    '$route' (to, from) {
      if (to.name === from.name) {
        window.location.reload()
      }
    }
  }
}
</script>

<template lang="pug">
    nav.admin-nav
      filter-component.filter(v-if="$route.name !== 'board'", :collection="profiles", @filter="emitFilteredProfiles")
      div.nav-links
        a.admin-link(href="/admin", target="_blank") Dashboard
        router-link.admin-link(v-for="route in routes", :to="{name: route}", v-if="$route.name !== route") {{route | capitalize}}
        select.admin-link(v-model="boardSlug", @change="navigateToBoard")
          option(:value="null") -- Go To Board --
          option(v-for="board in boards", :value="board.slug") {{board.title}}


</template>

<style>

@import "../../init/variables.css";

.admin-nav {
  padding: 1em;
  padding-right: 2em;
  border-bottom: 3px solid var(--themeColor);
  display: flex;
  justify-content: space-between;

  & .filter {
    label {
      margin-right: 5px;
    }
  }

  & .admin-links {
    display: flex;
    justify-content: flex-end;
  }

  & .admin-link {
    display: inline-block;
    padding: 5px;
    &:before {
      content: "⚪ ";
      color: var(--themeColor);
    }
  }

  & select.admin-link {
    width: 20em;
    margin-left: 1em;
    padding: 10px;
  }
}

</style>
