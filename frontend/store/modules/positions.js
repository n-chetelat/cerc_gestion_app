import axios from "axios"
import { keyBy } from "lodash-es"

const BASE_URL = `api/positions`

const state = {
  all: [],
  forms: [],
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  allPositions: state => state.all,
  positionForms: state => state.forms,
  positionFormsById: (state, getters) => keyBy(getters.positionForms, 'position_id')
}

// actions
const actions = {
  getAllPositions({ commit, getters }) {
    return axios.get(getters.endpoint).then(({ data }) => {
      commit('setPositions', data)
    })
  },
  getPositionForm({ commit, getters }, positionId) {
    return axios.get(`${getters.endpoint}/${positionId}/form`)
    .then(({ data }) => {
      commit('setPositionForms', data)
    })
  }
}

// mutations
const mutations = {
  setPositions(state, positions) {
    state.all = positions
  },
  setPositionForms(state, form) {
    state.forms.push(form)
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
