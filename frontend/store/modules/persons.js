import axios from "axios"
import qs from "qs"

const BASE_URL = "api/persons"

const state = {
  current: null
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  currentPerson: state => state.current,
}

// actions
const actions = {
  fetchPerson({ commit, getters }, { person_id, options }) {
    const query = qs.stringify(options)
    return axios.get(`${getters.endpoint}/${person_id}?${query}`).then(({ data }) => {
      commit("setCurrentPerson", data)
    })
  },
  setPerson({ commit }, person) {
    commit("setCurrentPerson", person)
  }
}

// mutations
const mutations = {
  setCurrentPerson(state, person) {
    state.current = person
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
