import "babel-polyfill"

import "./index.css";
import "./recruitment-info.css";
import "./tables.css";
import "./tooltip.css";

import Vue from 'vue'
import Vuex from 'vuex'
import store from '../store'
import router from '../router'
import App from '../components/app.vue'

import Vue2Filters from 'vue2-filters'
import VTooltip from 'v-tooltip'
import Transitions from 'vue2-transitions'

Vue.use(Vuex)

Vue.use(Vue2Filters)
Vue.use(VTooltip)
Vue.use(Transitions)

import axios from "axios"
axios.defaults.headers.common["X-CSRF-TOKEN"] = document.querySelector("meta[name='csrf-token']").getAttribute("content")

document.addEventListener('DOMContentLoaded', () => {
  let options = {
    el: document.getElementById("app"),
    store: new Vuex.Store(store),
    router
  }
  const app = new Vue({
    ...options,
    render: h => h(App)
  })
})
