import axios from "axios"

import { keyBy, groupBy, filter, differenceBy } from "lodash-es"

const PROFILE_URL = `api/profiles`
const PROFILE_FIELDS_URL = `api/profile_fields`
const PERSONS_URL = `api/persons`

const state = {
  all: [],
  fields: [],
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PROFILE_URL}`,
  profileFieldsEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PROFILE_FIELDS_URL}`,
  personsEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PERSONS_URL}`,
  profiles: state => state.all,
  profilesById: state => keyBy(state.all, "id"),
  fields: state => state.fields,
  fieldsById: state => keyBy(state.fields, "id"),
  profileFieldValuesByProfileId: (state) => {
    const map = {}
    for (const profile of state.all) {
      map[profile.id] = keyBy(profile.profile_fields, "profile_field_id")
    }
    return map
  },
  profilesByStatus: state => groupBy(state.all, "status"),
  activeProfiles: state => filter(state.all, p => p.status === "active"),
  timelineProfiles: state => filter(state.all, p => ["active", "incoming"].includes(p.status))
}

// actions
const actions = {
  fetchProfiles({ commit, getters }, { profilesLoaded }) {
    const offset = profilesLoaded
    return axios.get(getters.endpoint, { params: { offset } }).then(({ data }) => {
      commit("setProfiles", data)
    })
  },
  fetchProfileFields({ commit, getters }) {
    return axios.get(getters.profileFieldsEndpoint).then(({ data }) => {
      commit("setProfileFields", data)
    })
  },
  createProfile({ commit, getters }, params) {
    return axios.post(`${getters.endpoint}`, params).then(({ data }) => {
      commit("setPersonProfile", data)
    })
  },
  updatePersonData({ commit, getters }, { personId, field, newValue }) {
    const params = {}
    params[field] = newValue
    return axios.put(`${getters.endpoint}/${personId}`, params).then(({ data }) => {
      commit("setPersonProfile", data)
    })
  },
  markProfileAsFinished({ commit, getters }, personId) {
    return axios.put(`${getters.endpoint}/${personId}/finished`).then(({ data }) => {
      commit("setPersonProfile", data)
    })
  },
  markProfileAsCanceled({ commit, getters }, personId) {
    return axios.put(`${getters.endpoint}/${personId}/canceled`).then(({ data }) => {
      commit("setPersonProfile", data)
    })
  },
  createProfileData({ commit, getters }, { personId, profileFieldId, newValue }) {
    return axios.post(`${getters.personsEndpoint}/${personId}/profile_fields`, {profile_field_id: profileFieldId, data: newValue}).then(({ data }) => {
      commit("setPersonProfile", data)
    })
  },
  updateProfileData({ commit, getters }, { personId, personProfileFieldId, newValue }) {
    return axios.put(`${getters.personsEndpoint}/${personId}/profile_fields/${personProfileFieldId}`, {data: newValue}).then(({ data }) => {
      commit("setPersonProfile", data)
    })
  }
}

// mutations
const mutations = {
  setProfiles(state, profiles) {
    if (!state.all.length) {
      state.all = profiles
    } else {
      const newProfiles = differenceBy(profiles, state.all, "id")
      state.all = [...state.all, ...newProfiles]
    }
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
