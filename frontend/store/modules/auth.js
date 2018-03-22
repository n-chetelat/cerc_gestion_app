import axios from "axios"
import { keyBy } from "lodash-es"

const BASE_URL = "auth"

const state = {
  profile: null,
  authenticated: false
}

// getters
const getters = {
  isAuthenticated: state => state.authenticated,
}

// actions
const actions = {
  getRecruitmentInfo({ commit, getters }) {
    return axios.get(BASE_URL).then(({ data }) => {
      commit('setAuthenticated', data.authenticated)
    })
  }
}

// mutations
const mutations = {
  setAuthenticated(state, authenticated) {
    state.authenticated = authenticated
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
