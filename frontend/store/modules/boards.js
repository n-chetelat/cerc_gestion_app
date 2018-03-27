import axios from "axios"
import { keyBy } from "lodash-es"

const BASE_URL = "api/boards"

const state = {
  all: []
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  boardsById: state => keyBy(state.all, 'id')

}

// actions
const actions = {
  async fetchBoard({ commit, getters }, board_id) {
    let board = getters.boardsById[board_id]
    if (!board) {
      try {
        let board = await axios.get(`${getters.endpoint}/${board_id}`)
        commit('addBoard', board.data)
      } catch(error) {
        // TODO: handle error with modal
      }
    }
  },
}

// mutations
const mutations = {
  addBoard(state, board) {
    state.all.push(board)
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
