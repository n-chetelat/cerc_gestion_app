<script>

import { mapGetters, mapActions } from "vuex"

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
  },
  methods: {
    ...mapActions("boards", ["fetchAllBoards"]),
    navigateToBoard() {
      if (!this.boardSlug) return
      this.$router.push({name: "board", params: { boardSlug: this.boardSlug }})
    }
  },
  components: {
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
  justify-content: flex-end;

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
