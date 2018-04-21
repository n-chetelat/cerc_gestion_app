import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import store from './../store'

import RecruitmentForm from "./../components/recruitment-form.vue"
import Board from "./../components/board.vue"

const routes = [
  {
    path: "/",
    name: "home",
    component: RecruitmentForm
  },
  {
    path: "/admin/boards/:boardSlug",
    name: "board",
    component: Board,
    props:  (route) => ({ boardSlug: route.params.boardSlug })
  }
]

const router = new VueRouter({
  routes
})

export default router
