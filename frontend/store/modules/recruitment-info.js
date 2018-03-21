import axios from "axios"
import { keyBy } from "lodash-es"

const BASE_URL = "api/recruitment_info"

const state = {
  info: null
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  recruitmentInfo: state => state.info,
}

// actions
const actions = {
  getRecruitmentInfo({ commit, getters }) {
    return axios.get(getters.endpoint).then(({ data }) => {
      commit('setRecruitmentInfo', data.content)
    })
  },
}

// mutations
const mutations = {
  setRecruitmentInfo(state, info) {
    state.info = info
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
