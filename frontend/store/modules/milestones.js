import axios from "axios"

import { keyBy } from "lodash-es"

const MILESTONES_URL = `api/milestones`
const PERSONS_URL = `api/persons`

const state = {
  milestones: [],
  byPersonId: {},
}

// getters
const getters = {
  milestonesEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${MILESTONES_URL}`,
  personsEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${PERSONS_URL}`,
  milestones: state => state.milestones,
  milestonesById: state => keyBy(state.milestones, "id"),
  milestonesByPersonId: state => state.byPersonId,
}

// actions
const actions = {
  fetchMilestones({ commit, getters }) {
    return axios.get(getters.milestonesEndpoint).then(({ data }) => {
      commit("setMilestones", data)
    })
  },
  fetchPersonMilestones({ commit, getters }, personId) {
    return axios.get(`${getters.personsEndpoint}/${personId}/positions_milestones`).then(({ data }) => {
      commit("setPersonMilestones", data)
    })
  }
}

// mutations
const mutations = {
  setMilestones(state, milestones) {
    state.milestones = milestones
  },
  setPersonMilestones(state, personMilestones) {
    state.byPersonId[personMilestones.person_id] = personMilestones
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
