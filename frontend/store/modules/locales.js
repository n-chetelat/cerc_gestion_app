import axios from "axios"
import { keyBy, includes } from "lodash-es"

const state = {
  all: [
    {code: "en", label: "English", opposite: "fr"},
    {code: "fr", label: "Français",  opposite: "en"}
  ]
}

// getters
const getters = {
  currentPathnameLocale: state => window.location.pathname.split("/")[1],
  currentLocale: (state, getters) => (getters.currentPathnameLocale === "fr") ? "fr" : "en",
  localesByCode: state => keyBy(state.all, 'code')
}

// actions
const actions = {
  switchLocale({ commit, getters }) {
    const newLocale = getters.localesByCode[getters.currentLocale].opposite
    let newPathname = window.location.pathname
    if (!includes(["en", "fr"], getters.currentPathnameLocale)) {
      newPathname = `/${newLocale}${newPathname}`
    } else {
      newPathname = newPathname.replace(/^\/(?:fr|en)/, `/${newLocale}`)
    }
    const newUrl = `${window.location.origin}${newPathname}`
    window.location.replace(newUrl)
  },
}

// mutations
const mutations = {

}

export default {
  state,
  getters,
  actions,
  mutations,
  namespaced: true
}
