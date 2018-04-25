import axios from "axios"

const APPLICATIONS_URL = `api/applications`
const AUTOCOMPLETE_URL = `api/keywords`

const state = {
  allByApplication: {},
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${APPLICATIONS_URL}`,
  autocompleteEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${AUTOCOMPLETE_URL}?q=`,
  keywordsByApplication: state => state.allByApplication,
}

// actions
const actions = {
  fetchApplicationKeywords({ commit, getters }, applicationId) {
    return axios.get(`${getters.endpoint}/${applicationId}/keywords`).then(({data}) => {
      commit("setApplicationKeywords", { applicationId, keywords: data })
    })
  },
  updateKeywords({ commit, getters }, payload) {
    const { applicationId, params } = payload
    return axios.put(`${getters.endpoint}/${applicationId}/keywords`, params).then(({data}) => {
      commit("updateKeywords", { applicationId, keywords: data })
    })
  },
  removeKeywords({ commit, getters }, payload) {
    const { applicationId, params } = payload
    return axios.delete(`${getters.endpoint}/${applicationId}/keywords`, { params }).then(({data}) => {
      commit("updateKeywords", { applicationId, keywords: data })
    })
  }
}

// mutations
const mutations = {
  setApplicationKeywords(state, payload) {
    const { applicationId, keywords } = payload
    state.allByApplication[applicationId] = keywords
  },
  updateKeywords(state, payload) {
    const { applicationId, keywords } = payload
    state.allByApplication[applicationId] = keywords
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
