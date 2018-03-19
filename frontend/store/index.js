import Vue from 'vue'
import Vuex from 'vuex'
import positions from './modules/positions'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    positions
  },
})
