import "./index.css";
import "./form.css";

import "babel-polyfill"

import Vue from 'vue'
import store from '../store'
import App from '../components/app.vue'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById("app")
  const app = new Vue({
    el,
    store,
    render: h => h(App)
  })
})
