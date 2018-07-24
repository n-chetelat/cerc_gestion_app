import axios from "axios"
import Vue from "vue"

import { keyBy, groupBy, sortBy } from "lodash-es"

const MILESTONES_URL = `api/milestones`
const PERSON_MILESTONE_URL = `api/persons_positions_milestones`

const state = {
  milestones: [],
  milestonesByPersonId: {},
}

// getters
const getters = {
  milestonesEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${MILESTONES_URL}`,
  personsMilestonesEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PERSON_MILESTONE_URL}`,
  milestones: state => state.milestones,
  milestonesById: state => keyBy(state.milestones, "id"),
  milestonesByPosition: state => groupBy(state.milestones, "position_id"),
  milestonesByPersonId: state => state.milestonesByPersonId,
  milestonesBySemester: (state, getters, root, rootGetters) => {
    const structure = {}
    rootGetters['profiles/profiles'].forEach((profile) => {
      structure[profile.uuid] = groupBy(state.milestonesByPersonId[profile.uuid], (m) => m.semester)
    })
    return structure
  },
}

// actions
const actions = {
  fetchMilestones({ commit, getters }) {
    return axios.get(getters.milestonesEndpoint).then(({ data }) => {
      commit("setMilestones", data)
    })
  },
  fetchPersonMilestones({ commit, getters }) {
    return axios.get(`${getters.personsMilestonesEndpoint}`).then(({ data }) => {
      commit("setPersonMilestones", data)
    })
  },
  createPersonMilestone({ commit, getters }, params) {
    return axios.post(`${getters.personsMilestonesEndpoint}`, params).then(({ data }) => {
      commit("addPersonMilestone", data)
    })
  },
  updatePersonMilestone({ commit, getters }, params) {
    return axios.put(`${getters.personsMilestonesEndpoint}/${params.id}`, params).then(({ data }) => {
      commit("setPersonMilestone", data)
    })
  },
  destroyPersonMilestone({ commit, getters }, personMilestoneId) {
    return axios.delete(`${getters.personsMilestonesEndpoint}/${personMilestoneId}`).then(({ data }) => {
      commit("removePersonMilestone", data)
    })
  }
}

// mutations
const mutations = {
  setMilestones(state, milestones) {
    state.milestones = milestones
  },
  setPersonMilestones(state, personMilestones) {
    state.milestonesByPersonId = groupBy(personMilestones, "person_id")
    Object.keys(state.milestonesByPersonId).forEach((person_id) => {
      state.milestonesByPersonId[person_id] = sortBy(state.milestonesByPersonId[person_id], (pm) => {
        return pm.time_interval_ordinality
      })
    })
  },
  addPersonMilestone(state, personMilestone) {
    const personMilestones = state.milestonesByPersonId[personMilestone.person_id] || []
    const newMilestonesByPersonId = { ...state.milestonesByPersonId }
    newMilestonesByPersonId[personMilestone.person_id] = sortBy([...personMilestones, personMilestone], (pm) => {
      return pm.time_interval_ordinality
    })
    state.milestonesByPersonId = newMilestonesByPersonId
  },
  setPersonMilestone(state, personMilestone) {
    const personMilestones = state.milestonesByPersonId[personMilestone.person_id]
    const index = personMilestones.findIndex(pm => pm.id === personMilestone.id)
    state.milestonesByPersonId[personMilestone.person_id].splice(index, 1, personMilestone)
  },
  removePersonMilestone(state, personMilestone) {
    const personMilestones = state.milestonesByPersonId[personMilestone.person_id]
    const index = personMilestones.findIndex(pm => pm.id === personMilestone.id)
    state.milestonesByPersonId[personMilestone.person_id].splice(index, 1)
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
