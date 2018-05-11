import axios from "axios"

const BASE_URL = "api/recruitment_info"

const state = {
  content: null,
  copyright: null,
  positionLabel: null,
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  recruitmentInfo: state => state.content,
  pageCopyright: state => state.copyright,
  positionLabel: state => state.positionLabel,
}

// actions
const actions = {
  getRecruitmentInfo({ commit, getters }) {
    return axios.get(getters.endpoint).then(({ data }) => {
      commit('setRecruitmentInfo', data)
    })
  },
}

// mutations
const mutations = {
  setRecruitmentInfo(state, info) {
    state.content = info.content
    state.copyright = info.copyright
    state.positionLabel = info.positions
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
