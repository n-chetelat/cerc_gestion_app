import axios from "axios"
import { keyBy } from "lodash-es"

const BASE_URL = `api/applications`

const state = {
  current: {},
  all: []
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  getApplications: state => state.all
}

// actions
const actions = {
  sendApplication({ commit, getters }, values) {
    const formData = new FormData()
    const data = Array.from(values).forEach((value) => {
      if (value.value.constructor === Array) {
        value.value.forEach((item, index) => {
          formData.append(`${value.inputName}[${index}]`, item)
        })
      } else {
        formData.append(value.inputName, value.value)
      }
    })
    return axios.post(getters.endpoint, formData).then(({ data }) => {
      commit('setCurrentApplication', data)
    })
  },
  fetchApplications({ commit, getters }) {
    axios.get(getters.endpoint).then(({ data }) => {
      commit("setApplications", data)
    })
  }
}

// mutations
const mutations = {
  setCurrentApplication(state, application) {
    state.current = application
  },
  setApplications(state, applications) {
    state.all = applications
  }
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
