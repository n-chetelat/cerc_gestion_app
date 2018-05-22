import axios from "axios"
import { keyBy, findIndex, find, filter  } from "lodash-es"

const BOARD_URL = "api/boards"
const PHASE_URL = "api/phases"

const state = {
  current: null,
  emailTemplatesByPhase: {}
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BOARD_URL}`,
  phaseEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PHASE_URL}`,
  currentBoard: state => state.current,
  phasesById: state => {
    if (!state.current) return {}
    return keyBy(state.current.phases, "uuid")
  },
  finalPhases: state => {
    if (state.current) {
      return filter(state.current.phases, (ph) => ph.final)
    } else return []
  },
  nonFinalPhases: state => {
    if (state.current) {
      return filter(state.current.phases, (ph) => !ph.final)
    } else return []
  },
  emailTemplatesByPhase: state => state.emailTemplatesByPhase,
}

// actions
const actions = {
   fetchBoard({ commit, getters }, boardId) {
    return axios.get(`${getters.endpoint}/${boardId}`).then(({ data }) => {
      commit('setCurrentBoard', data)
    })
  },
  changePersonPhase({ commit, getters }, payload) {
    const { phaseId, personId, oldPhaseId } = payload
    return axios.put(`${getters.phaseEndpoint}/${phaseId}/persons/${personId}`).then(({ data }) => {
      commit("removePersonFromPhase", { oldPhaseId, person: data })
      commit("addPersonToPhase", { phaseId, person: data })
    })
  },
  fetchPhaseEmailTemplate({ commit, getters }, payload) {
    const { phaseId, personId } = payload
    return axios.get(`${getters.phaseEndpoint}/${phaseId}/email_template`, {params: {person_id: personId}}).then(({ data }) => {
      commit("setEmailTemplate", { phaseId, emailTemplate: data })
    })
  },
}

// mutations
const mutations = {
  setCurrentBoard(state, board) {
    state.current = board
  },
  addPersonToPhase(state, payload) {
    const { phaseId, person } = payload
    const phase = find(state.current.phases, (phase) => phase.uuid === phaseId)
    phase.persons.push(person)
  },
  removePersonFromPhase(state, payload) {
    const { oldPhaseId, person } = payload
    const persons = find(state.current.phases, (phase) => phase.uuid === oldPhaseId).persons
    const personIndex = findIndex(persons, (p) => p.uuid === person.uuid)
    persons.splice(personIndex, 1)
  },
  setEmailTemplate(state, payload) {
    const { phaseId,  emailTemplate } = payload
    state.emailTemplatesByPhase[phaseId] = emailTemplate
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
