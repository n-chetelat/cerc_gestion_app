import "./index.css";
import "./form.css";

import "babel-polyfill"

import Vue from 'vue'
import store from '../store'
import router from '../router'
import App from '../components/app.vue'
import AppAdmin from '../components/app-admin.vue'

document.addEventListener('DOMContentLoaded', () => {
  let options = { store }
  let el = document.getElementById("app-admin")
  let component = AppAdmin
  if (el) {
    options = {
      ...options,
      el: document.getElementById("app-admin"),
      router
    }
  } else {
    options = {
      ...options,
      el: document.getElementById("app"),
    }
    component = App
  }
  const app = new Vue({
    ...options,
    render: h => h(component)
  })
})
