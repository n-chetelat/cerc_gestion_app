import axios from "axios"
import { findIndex } from "lodash-es"

const APPLICATIONS_URL = `api/applications`

const state = {
  allByApplication: {},
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${APPLICATIONS_URL}`,
  commentsByApplication: state => state.allByApplication,
}

// actions
const actions = {
  fetchApplicationComments({ commit, getters }, applicationId) {
    return axios.get(`${getters.endpoint}/${applicationId}/comments`).then(({data}) => {
      commit("setApplicationComments", { applicationId, comments: data })
    })
  },
  createComment({ commit, getters }, payload) {
    const { applicationId, params } = payload
    return axios.post(`${getters.endpoint}/${applicationId}/comments`, params).then(({data}) => {
      commit("addNewComment", { applicationId, comment: data })
    })
  },
  updateComment({ commit, getters }, payload) {
    const { applicationId, commentId, params } = payload
    return axios.put(`${getters.endpoint}/${applicationId}/comments/${commentId}`, params).then(({data}) => {
      commit("updateExistingComment", { applicationId, comment: data })
    })
  }
}

// mutations
const mutations = {
  setApplicationComments(state, payload) {
    const { applicationId, comments } = payload
    state.allByApplication[applicationId] = comments
  },
  addNewComment(state, payload) {
    const { applicationId, comment } = payload
    state.allByApplication[applicationId] = [comment].concat(state.allByApplication[applicationId])
  },
  updateExistingComment(state, payload) {
    const { applicationId, comment } = payload
    const comments = state.allByApplication[applicationId]
    const index = findIndex(comments, (c) => c.id === comment.id)
    if (index > -1) {
      comments[index] = comment
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
