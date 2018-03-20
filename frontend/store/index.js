import Vue from 'vue'
import Vuex from 'vuex'
import locales from './modules/locales'
import positions from './modules/positions'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    locales,
    positions,
  },
})
