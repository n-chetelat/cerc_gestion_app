<script>

import { mapGetters } from "vuex"

export default {
  name: "ProfilesSidebar",
  props: {
    staticFields: {
      required: true, default: {}
    },
    dynamicFields: {
      required: true, default: []
    }
  },
  data() {
    return {
      sidebarOpen: false,
      selectedFields: [],
    }
  },

  methods: {
    toggleSidebarOpen() {
      this.sidebarOpen = !this.sidebarOpen
      this.$emit("toggle", this.sidebarOpen)
    },
    toggleFieldVisibility(value) {
      if (value === "selectAll") {
        this.addAllColumns()
      } else if (value === "hideAll") {
        this.selectedFields = []
      }
    },
    addRememberedColumns() {
      if (localStorage.getItem("profile-fields")) {
        this.selectedFields = JSON.parse(localStorage.getItem("profile-fields"))
      } else {
        this.addAllColumns()
      }
    },
    addAllColumns() {
      const dynamicFieldIds = this.dynamicFields.map(f => f.id)
      const staticFieldIds = Object.keys(this.staticFields)
      this.selectedFields = [...staticFieldIds, ...dynamicFieldIds]
    },
    applyFieldFilter() {
      this.$emit("filter", this.selectedFields)
    }
  },
  components: {
  },
  watch: {
    dynamicFields: function(val, oldVal) {
      if (oldVal.length) return // Trigger only on transition from empty array to full
      if (val.length) {
        this.addRememberedColumns()
      }
    },
  },
}
</script>



<template lang="pug">
  aside.profiles-sidebar
    div.menu-icons
      button.toggle-menu(@click="toggleSidebarOpen", :class="{'--open': sidebarOpen}")
    div.actions
      button(type="button", @click="$emit('modal', 'new-profile')") Create new profile
      div.visible-columns
        div.column-line
          button(type="button", @click="toggleFieldVisibility('selectAll')") Select all columns
        div.column-line
          button(type="button", @click="toggleFieldVisibility('hideAll')") Hide all columns
        hr
        div.field-columns
          div.column-line(v-for="(label, key) in staticFields")
            input(type="checkbox", :value="key", v-model="selectedFields")
            label {{label}}

          div.column-line(v-for="field in dynamicFields")
            input(type="checkbox", :value="field.id", v-model="selectedFields")
            label {{field.label}}
        button.apply-filter-btn(type="button", @click="applyFieldFilter") Apply
</template>

<style>

  @import "../../init/variables.css";

  .profiles-sidebar {
    background-color: var(--themeColor);
    display: flex;

    & .menu-icons {
      width: 3em;
      text-align: center;
    }

    & .actions {
      width: var(--profilesSidebarOffset)em;
      display: flex;
      flex-direction: column;
      margin: 3em auto;
      padding: 1em;

      & button {
        padding: 0;
        min-height: 3em;
      }
    }

    & .visible-columns {
      background-color: white;
      padding: 1em;
      margin-top: 1em;

      & .field-columns {
        height: 300px;
        overflow-y: auto;
      }
      & .apply-filter-btn {
        width: 100%;
      }
      & .column-line {
        display: flex;
        padding-bottom: 5px;
        & input {
          width: 15%;
        }
        & button {
          padding: 2px;
          color: var(--navColor);
          background-color: white;
          border: 2px solid var(--navColor);
          text-transform: none;
          letter-spacing: 1px;
          min-width: 15em;
        }
      }
    }

    & .toggle-menu {
      width: var(--menuSpace)em;
      height: 3em;
      background: url("../../static/icons/menu.svg") center center no-repeat;
      margin: 0;
      padding: 0;
      &.--open {
        background: url("../../static/icons/x-charcoal.svg") center center no-repeat;
      }
    }
  }

</style>
