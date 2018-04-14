import axios from "axios"
import { keyBy } from "lodash-es"

const BASE_URL = `api/persons`

const state = {
  allByPerson: {}
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  emailByPerson: state => state.allByPerson,
}

// actions
const actions = {
  fetchPersonEmail({ commit, getters }, personId) {
    return axios.get(`${getters.endpoint}/${personId}/email`).then(({data}) => {
      commit("setPersonEmail", data)
    })
  },
}

// mutations
const mutations = {
  setPersonEmail(state, email) {
    state.allByPerson[email.person_id] = email
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
