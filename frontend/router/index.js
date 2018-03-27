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
    path: "/admin/applications",
    name: "applications",
    component: Board,
    props:  { boardId: "1" }
  },
  {
    path: "/admin/boards/:boardId",
    name: "board",
    component: Board,
    props:  (route) => ({ boardId: route.params.boardId })
  }
]

const router = new VueRouter({
  routes
})

export default router
