import axios from "axios"

import { keyBy } from "lodash-es"

const BASE_URL = `api`

const state = {
  semesters: [],
  months: [],
  interval: {min: null, max: null},
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  semesters: state => state.semesters,
  months: state => state.months,
  interval: state => state.interval
}

// actions
const actions = {
  fetchSemesters({ commit, getters }) {
    return axios.get(`${getters.endpoint}/semesters`).then(({ data }) => {
      commit("setSemesters", data)
    })
  },
  fetchMonths({ commit, getters }) {
    return axios.get(`${getters.endpoint}/months`).then(({ data }) => {
      commit("setMonths", data)
    })
  },
  // The earlies and latest dates to show on the timeline
  fetchActiveProfileInterval({ commit, getters }) {
    return axios.get(`${getters.endpoint}/timeline`).then(({ data }) => {
      commit("setInterval", data)
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
  setInterval(state, interval) {
    state.interval = interval
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
