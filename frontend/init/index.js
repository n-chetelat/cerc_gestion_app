import "babel-polyfill"

import "./index.css";
import "./recruitment-info.css";

import Vue from 'vue'
import store from '../store'
import router from '../router'
import App from '../components/app.vue'
import AppAdmin from '../components/app-admin.vue'

import axios from "axios"
axios.defaults.headers.common["X-CSRF-TOKEN"] = document.querySelector("meta[name='csrf-token']").getAttribute("content")

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
