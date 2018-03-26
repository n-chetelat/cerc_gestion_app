import axios from "axios"

const BASE_URL = "api/phases"

const state = {
  all: []
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  allPhases: state => state.all,
}

// actions
const actions = {
  fetchPhases({ commit, getters }) {
    return axios.get(getters.endpoint).then(({ data }) => {
      commit('setAllPhases', data)
    })
  },
}

// mutations
const mutations = {
  setAllPhases(state, phases) {
    state.all = phases
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
