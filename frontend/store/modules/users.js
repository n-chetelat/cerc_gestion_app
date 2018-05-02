import axios from "axios"
import { filter } from "lodash-es"

const BASE_URL = "api/users"

const state = {
  current: null,
  loggedIn: [],
  messages: []
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  currentUser: state => state.current,
  loggedInUsers: state => state.loggedIn,
  loggedInMessages: state => state.messages,
}

// actions
const actions = {
  fetchUserInfo({ commit, getters }) {
    return axios.get(`${getters.endpoint}`).then(({ data }) => {
      commit("setCurrentUser", data)
    })
  },
  addStatusMessage({ commit }, message) {
    commit("addMessage", message)
  },
  setLoggedInUsers({ commit }, users) {
    commit("setLoggedInUsers", users)
  }
}

// mutations
const mutations = {
  setCurrentUser(state, user) {
    state.current = user
  },
  addMessage(state, message) {
    if (state.current.email === message.author.email) return
    state.messages = [message].concat(state.messages)
  },
  setLoggedInUsers(state, users) {
    const loggedInUsers = filter(users, (user) => {
      return user.email !== state.current.email
    })
    state.loggedIn = loggedInUsers
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
