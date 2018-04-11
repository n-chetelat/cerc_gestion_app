import axios from "axios"
import { keyBy, findIndex, find  } from "lodash-es"

const BOARD_URL = "api/boards"
const PHASE_URL = "api/phases"

const state = {
  current: null
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BOARD_URL}`,
  phaseEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PHASE_URL}`,
  currentBoard: state => state.current
}

// actions
const actions = {
   fetchBoard({ commit, getters }, board_id) {
    return axios.get(`${getters.endpoint}/${board_id}`).then(({ data }) => {
      commit('setCurrentBoard', data)
    })
  },
  changePersonPhase({ commit, getters }, payload) {
    const { phaseId, personId, oldPhaseId } = payload
    return axios.put(`${getters.phaseEndpoint}/${phaseId}/persons/${personId}`).then(({ data }) => {
      commit("removePersonFromPhase", { oldPhaseId, person: data })
      commit("addPersonToPhase", { phaseId, person: data })
    })
  }
}

// mutations
const mutations = {
  setCurrentBoard(state, board) {
    state.current = board
  },
  addPersonToPhase(state, payload) {
    const { phaseId, person } = payload

    find(state.current.phases, (phase) => phase.id === phaseId)
      .persons.push(person)
  },
  removePersonFromPhase(state, payload) {
    const { oldPhaseId, person } = payload

    const persons = find(state.current.phases, (phase) => phase.id === oldPhaseId).persons
    const personIndex = findIndex(persons, (p) => p.id === person.id)
    persons.splice(personIndex, 1)
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
