import axios from "axios"
import { keyBy } from "lodash-es"

const PERSON_EMAIL_URL = `api/persons`
const THREADS_URL = `api/email/threads`

const state = {
  allByPerson: {}
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PERSON_EMAIL_URL}`,
  threadsEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${THREADS_URL}`,
  emailByPerson: state => state.allByPerson,
}

// actions
const actions = {
  fetchPersonEmail({ commit, getters }, personId) {
    return axios.get(`${getters.endpoint}/${personId}/email`).then(({data}) => {
      commit("setPersonEmail", data)
    })
  },
  sendEmail({ commit, getters }, payload) {
    const { threadId, params } = payload
    return axios.put(`${getters.threadsEndpoint}/${threadId}`, params)
  }
}

// mutations
const mutations = {
  setPersonEmail(state, email) {
    state.allByPerson[email.person_id] = email
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
