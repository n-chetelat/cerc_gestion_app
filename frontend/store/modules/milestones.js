import axios from "axios"
import Vue from "vue"

import { keyBy, groupBy } from "lodash-es"

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
    return axios.post(`${getters.personsMilestonesEndpoint}`, params).then(({ data }) => {
      commit("setPersonMilestone", data)
    })
  },
}

// mutations
const mutations = {
  setMilestones(state, milestones) {
    state.milestones = milestones
  },
  setPersonMilestones(state, personMilestones) {
    state.milestonesByPersonId = groupBy(personMilestones, "person_id")
  },
  addPersonMilestone(state, personMilestone) {
    const personMilestones = state.milestonesByPersonId[personMilestone.person_id] || []
    const newMilestonesByPersonId = { ...state.milestonesByPersonId }
    newMilestonesByPersonId[personMilestone.person_id] = [...personMilestones, personMilestone]
    state.milestonesByPersonId = newMilestonesByPersonId
  },
  setPersonMilestone(state, personMilestone) {
    const personMilestones = state.milestonesByPersonId[personMilestone.person_id]
    const index = personMilestones.findIndex(pm => pm.id === personMilestone.id)
    state.milestonesByPersonId[personMilestone.person_id].splice(index, 1, personMilestone)
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
