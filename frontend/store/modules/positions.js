import axios from "axios"

const BASE_URL = "api/positions"

const state = {
  all: []
}

// getters
const getters = {
  allPositions: state => state.all
}

// actions
const actions = {
  getAllPositions ({ commit }) {
    return axios.get(BASE_URL).then(({ data }) => {
      commit('setPositions', data)
    })
  }
}

// mutations
const mutations = {
  setPositions (state, positions) {
    state.all = positions
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}
