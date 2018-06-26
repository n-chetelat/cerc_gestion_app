import axios from "axios"

import { keyBy } from "lodash-es"

const BASE_URL = `api/profiles`
const PROFILE_FIELDS_URL = `api/profile_fields`
const PERSONS_URL = `api/persons`

const state = {
  all: [],
  fields: [],
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  profileFieldsEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PROFILE_FIELDS_URL}`,
  personsEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PERSONS_URL}`,
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
  },
  updatePersonData({ commit, getters }, { personId, field, newValue }) {
    const params = {}
    params[field] = newValue
    return axios.put(`${getters.personsEndpoint}/${personId}`, {...params, profile: true}).then(({ data }) => {
      commit("setPersonProfile", data)
    })
  },
  createProfileData({ commit, getters }, { personId, profileFieldId, newValue }) {
    return axios.post(getters.endpoint, {person_id: personId, profile_field_id: profileFieldId, data: newValue}).then(({ data }) => {
      commit("setPersonProfile", data)
    })
  },
  updateProfileData({ commit, getters }, { personProfileFieldId, newValue }) {
    return axios.put(`${getters.endpoint}/${personProfileFieldId}`, {data: newValue}).then(({ data }) => {
      commit("setPersonProfile", data)
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
  setPersonProfile(state, profile) {
    const person_profile_index = state.all.findIndex((p) => p.id === profile.id)
    if (person_profile_index < 0) {
      state.all = [...state.all, profile]
    } else {
      state.all.splice(person_profile_index, 1, profile)
    }
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
