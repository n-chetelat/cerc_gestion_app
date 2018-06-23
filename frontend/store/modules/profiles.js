import axios from "axios"

import { keyBy } from "lodash-es"

const BASE_URL = `api/profiles`
const PROFILE_FIELDS_URL = `api/profile_fields`

const state = {
  all: [],
  fields: [],
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  profileFieldsEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PROFILE_FIELDS_URL}`,
  profiles: state => state.all,
  fields: state => state.fields,
  profileFieldValuesByProfileId: (state) => {
    const map = {}
    for (const profile of state.all) {
      map[profile.id] = keyBy(profile.profile_fields, "profile_field_id")
    }
    return map
  },
}

// actions
const actions = {
  fetchProfiles({ commit, getters }) {
    return axios.get(getters.endpoint).then(({ data }) => {
      commit("setProfiles", data)
    })
  },
  fetchProfileFields({ commit, getters }) {
    return axios.get(getters.profileFieldsEndpoint).then(({ data }) => {
      commit("setProfileFields", data)
    })
  }
}

// mutations
const mutations = {
  setProfiles(state, profiles) {
    state.all = profiles
  },
  setProfileFields(state, fields) {
    state.fields = fields
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
