import Vue from 'vue'
import Vuex from 'vuex'
import locales from './modules/locales'
import recruitmentInfo from './modules/recruitment-info'
import positions from './modules/positions'

Vue.use(Vuex)

export default new Vuex.Store({
  getters: {
    isAuthenticated: state => false
  },
  modules: {
    locales,
    recruitmentInfo,
    positions,
  },
})
