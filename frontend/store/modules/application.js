import axios from "axios"
import { keyBy } from "lodash-es"

const BASE_URL = `api/applications`

const state = {
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
}

// actions
const actions = {
  sendApplication({ commit, getters }, values) {
    const formData = new FormData()
    const data = Array.from(values).forEach((value) => {
      if (value.value && (value.value.constructor === Array)) {
        value.value.forEach((item, index) => {
          formData.append(`${value.inputName}[${index}]`, item)
        })
      } else if (value.value) {
        formData.append(value.inputName, value.value)
      }
    })
    return axios.post(getters.endpoint, formData)
  },
  updateApplication({ commit, getters }, payload) {
    const { applicationId, values } = payload
    const formData = new FormData()
    const data = Array.from(values).forEach((value) => {
      if (value.fieldData && (value.fieldData.constructor === Array)) {
        value.fieldData.forEach((item, index) => {
          formData.append(`${value.inputName}[${index}]`, item)
        })
      } else if (value.fieldData) {
        formData.append(value.inputName, value.fieldData)
      }
    })
    return axios.put(`${getters.endpoint}/${applicationId}`, formData)
  },
  async fetchApplication({ commit, getters }, applicationId) {
    return axios.get(`${getters.endpoint}/${applicationId}`)
  },
}

// mutations
const mutations = {
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
