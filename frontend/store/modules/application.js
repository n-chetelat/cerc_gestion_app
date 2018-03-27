import axios from "axios"
import { keyBy } from "lodash-es"

const BASE_URL = `api/applications`

const state = {
  current: null,
  all: []
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  currentApplication: state => state.current,
  getApplications: state => state.all
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
      } else {
        formData.append(value.inputName, value.value)
      }
    })
    return axios.post(getters.endpoint, formData)
  },
  async fetchApplication({ commit, getters }, applicationId) {
    try {
      const application = await axios.get(`${getters.endpoint}/${applicationId}`)
      commit("setCurrentApplication", application.data)
    } catch(error) {
      // TODO: handle error with modal
    }
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
