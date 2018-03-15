import "./index.css"

import Vue from 'vue'
import App from '../components/app.vue'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById("app")
  const app = new Vue({
    el,
    render: h => h(App)
  })

  console.log(app)
})
