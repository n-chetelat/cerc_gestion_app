import axios from "axios"
import { keyBy } from "lodash-es"

const BASE_URL = `api/email`

const state = {
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
}

// actions
const actions = {
  getPersonEmail({ commit, getters }, personId) {
    return axios.get(getters.endpoint)
  },
}

// mutations
const mutations = {
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
