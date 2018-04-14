import Vue from 'vue'
import Vuex from 'vuex'

import locales from './modules/locales'

import recruitmentInfo from './modules/recruitment-info'
import positions from './modules/positions'
import application from './modules/application'
import boards from './modules/boards'
import email from './modules/email'

Vue.use(Vuex)

export default new Vuex.Store({
  getters: {
    currentHost: (state, getters) => `${process.env.RAILS_HOST}/${getters["locales/currentLocale"]}`,
    isAuthenticated: state => false
  },
  modules: {
    locales,
    recruitmentInfo,
    positions,
    application,
    boards,
    email
  },
})
