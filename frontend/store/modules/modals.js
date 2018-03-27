import axios from "axios"

const BASE_URL = "api/boards"

const state = {
  current: null,
  visible: false,
}

// getters
const getters = {
  endpoint: (state, getters, root, rootGetters) => `${rootGetters.currentHost}/${BASE_URL}`,
  modalName: store => store.current,
  modalVisible: store => store.visible,
}

// actions
const actions = {
  openModal({ commit, getters }, name) {
    commit("setModalName", name)
    commit("setModalVisibility", true)
  },
  closeModal({ commit, getters }) {
    commit("setModalVisibility", false)
    commit("setModalName", null)
  },
}

// mutations
const mutations = {
  setModalName(state, name) {
    state.current = name
  },
  setModalVisibility(state, value) {
    state.visible = value
  },
}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
