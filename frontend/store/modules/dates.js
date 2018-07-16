import axios from "axios"

import { keyBy } from "lodash-es"

const BASE_URL = `api`

const state = {
  semesters: [],
  months: [],
  timeline: [],
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  semesters: state => state.semesters,
  months: state => state.months,
  timelineDates: state => state.timeline,
  monthDatesBySemester: state => {

  }
}

// actions
const actions = {
  fetchSemesters({ commit, getters }, params={}) {
    return axios.get(`${getters.endpoint}/semesters`, { params }).then(({ data }) => {
      commit("setSemesters", data)
    })
  },
  fetchMonths({ commit, getters }, params={}) {
    return axios.get(`${getters.endpoint}/months`, { params }).then(({ data }) => {
      commit("setMonths", data)
    })
  },
  // The earlies and latest dates to show on the timeline
  fetchActiveProfileTimelineDates({ commit, getters }) {
    return axios.get(`${getters.endpoint}/timeline`).then(({ data }) => {
      commit("setTimeline", data)
    })
  }
}

// mutations
const mutations = {
  setSemesters(state, semesters) {
    state.semesters = semesters
  },
  setMonths(state, months) {
    state.months = months
  },
  setTimeline(state, timeline) {
    state.timeline = timeline
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
