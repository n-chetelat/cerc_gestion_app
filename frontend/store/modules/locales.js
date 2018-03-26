import axios from "axios"

const state = {
  current: "en",
}

// getters
const getters = {
  currentLocale: state => state.current || "en",
}

// actions
const actions = {
  async switchLocale({ commit, getters }) {
    const newLocale = (getters.currentLocale === "en") ? "fr" : "en"
    commit("setCurrentLocale", newLocale)
  },
}

// mutations
const mutations = {
  setCurrentLocale(state, locale) {
    state.current = locale
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
