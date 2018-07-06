import axios from "axios"

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
  }
}

// mutations
const mutations = {
  setMilestones(state, milestones) {
    state.milestones = milestones
  },
  setPersonMilestones(state, personMilestones) {
    state.milestonesByPersonId = groupBy(personMilestones, "person_id")
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
