import axios from "axios"

const BASE_URL = "api/users"

const state = {
  current: null
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  currentUser: state => state.current
}

// actions
const actions = {
  fetchUserInfo({ commit, getters }) {
    return axios.get(`${getters.endpoint}`).then(({ data }) => {
      commit("setCurrentUser", data)
    })
  }
}

// mutations
const mutations = {
  setCurrentUser(state, user) {
    state.current = user
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
