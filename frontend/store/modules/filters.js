import axios from "axios"

import { filter } from "lodash-es"

const BASE_URL = `api/profiles/filters`

const state = {
  filtered: [],
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  filteredProfiles: state => state.filtered,
  filteredProfileIds: state => state.filtered.map((f) => f.id),
}

// actions
const actions = {
  filterProfilesByQueryString({ commit, getters }, params) {
    if (!params.q || !params.q.length) {
      commit("setFilteredProfiles", [])
    }
    return axios.get(getters.endpoint, { params }).then(({ data }) => {
      commit("setFilteredProfiles", data)
    })
  },
}

// mutations
const mutations = {
  setFilteredProfiles(state, profiles) {
    state.filtered = profiles
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
