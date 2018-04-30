import Vue from 'vue'
import Vuex from 'vuex'

import locales from './modules/locales'

import recruitmentInfo from './modules/recruitment-info'
import users from './modules/users'
import positions from './modules/positions'
import application from './modules/application'
import boards from './modules/boards'
import email from './modules/email'
import comments from './modules/comments'
import keywords from './modules/keywords'

Vue.use(Vuex)

export default new Vuex.Store({
  getters: {
    currentHost: (state, getters) => `${process.env.RAILS_HOST}/${getters["locales/currentLocale"]}`,
    isAuthenticated: state => false
  },
  modules: {
    locales,
    recruitmentInfo,
    users,
    positions,
    application,
    boards,
    email,
    comments,
    keywords
  },
})
