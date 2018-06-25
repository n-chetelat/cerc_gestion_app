import axios from "axios"

import { keyBy } from "lodash-es"

const SEMESTERS_URL = `api/semesters`
const MONTHS_URL = `api/months`

const state = {
  semesters: [],
  months: [],
}

// getters
const getters = {
  semestersEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${SEMESTERS_URL}`,
  monthsEndpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${MONTHS_URL}`,
  semesters: state => state.semesters,
  months: state => state.months,
}

// actions
const actions = {
  fetchSemesters({ commit, getters }) {
    return axios.get(getters.semestersEndpoint).then(({ data }) => {
      commit("setSemesters", data)
    })
  },
  fetchMonths({ commit, getters }) {
    return axios.get(getters.monthsEndpoint).then(({ data }) => {
      commit("setMonths", data)
    })
  },
}

// mutations
const mutations = {
  setSemesters(state, semesters) {
    state.semesters = semesters
  },
  setMonths(state, months) {
    state.months = months
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
