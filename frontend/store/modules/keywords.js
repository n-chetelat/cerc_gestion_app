import axios from "axios"
import { pull } from "lodash-es"

const APPLICATIONS_URL = `api/applications`

const state = {
  allByApplication: {},
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${APPLICATIONS_URL}`,
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
    const { applicationId, commentId, params } = payload
    return axios.put(`${getters.endpoint}/${applicationId}/keywords`, params).then(({data}) => {
      commit("addKeyword", { applicationId, keywords: data })
    })
  },
  removeKeywords({ commit, getters }, payload) {
    const { applicationId, commentId, params } = payload
    return axios.delete(`${getters.endpoint}/${applicationId}/keywords`, params).then(({data}) => {
      commit("removeKeyword", { applicationId, keywords: data })
    })
  }
}

// mutations
const mutations = {
  setApplicationKeywords(state, payload) {
    const { applicationId, keywords } = payload
    state.allByApplication[applicationId] = keywords
  },
  removeKeyword(state, payload) {
    const { applicationId, keywords } = payload
    state.allByApplication[applicationId] = state.allByApplication[applicationId].push(keyword)
  },
  addKeywords(state, payload) {
    const { applicationId, keywords } = payload
    const minusRemoved = pull(state.allByApplication[applicationId], keywords)
    state.allByApplication[applicationId] = minusRemoved
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
