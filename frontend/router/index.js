import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import store from './../store'

import RecruitmentForm from "./../components/recruitment-form.vue"
import RecruitmentAdmin from "./../components/recruitment-admin.vue"

const routes = [
  {
    path: "/",
    name: "home",
    component: RecruitmentForm
  },
  {
    path: "/admin/applications",
    name: "applications",
    component: RecruitmentAdmin,
  }
]

const router = new VueRouter({
  routes
})

export default router
