import axios from "axios"

const APPLICATIONS_URL = `api/applications`

const state = {
  allByApplication: {}
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
      // update current data
    })
  },
  updateComment({ commit, getters }, payload) {
    const { applicationId, commentId, params } = payload
    return axios.put(`${getters.endpoint}/${applicationId}/comments/${commentId}`, params)
  }
}

// mutations
const mutations = {
  setApplicationComments(state, payload) {
    const { applicationId, comments } = payload
    state.allByApplication[applicationId] = comments
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
