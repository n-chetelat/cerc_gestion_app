import axios from "axios"

const BASE_URL = `api/profiles`

const state = {
  csvProfiles: [],
  csvFields: []
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  profilesForCSV: state => state.csvProfiles,
  fieldsForCSV: state => state.csvFields,
}

// actions
const actions = {
  storeFilteredProfilesForCSV({ commit }, profileIds) {
    commit("storeProfilesForCSV", profileIds)
  },
  storeFilteredFieldsForCSV({ commit }, fieldIds) {
    commit("storeFieldsForCSV", fieldIds)
  },
  resetCSVFilters({ commit }) {
    commit("storeProfilesForCSV", [])
    commit("storeFieldsForCSV", [])
  }
}

// mutations
const mutations = {
  storeProfilesForCSV(state, profileIds) {
    state.csvProfiles = profileIds
  },
  storeFieldsForCSV(state, fieldIds) {
    state.csvFields = fieldIds
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
