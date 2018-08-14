import locales from './modules/locales'

import recruitmentInfo from './modules/recruitment-info'
import users from './modules/users'
import positions from './modules/positions'
import application from './modules/application'
import boards from './modules/boards'
import email from './modules/email'
import comments from './modules/comments'
import keywords from './modules/keywords'
import profiles from './modules/profiles'
import dates from './modules/dates'
import milestones from './modules/milestones'
import filters from './modules/filters'
import csv from './modules/csv'

const store = {
  getters: {
    currentHost: (state, getters) => `${process.env.RAILS_HOST}/${getters["locales/currentLocale"]}`,
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
    keywords,
    profiles,
    dates,
    milestones,
    filters,
    csv,
  },
}

export default store
