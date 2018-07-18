import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import store from "../store"

import RecruitmentForm from "./../components/recruitment-form.vue"
import Board from "./../components/board.vue"
import Profiles from "./../components/profiles.vue"
import Timeline from "./../components/timeline.vue"

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
  },
  {
    path: "/admin/profiles",
    name:"profiles",
    component: Profiles,
  },
  {
    path: "/admin/timeline",
    name:"timeline",
    component: Timeline,
  }
]

const router = new VueRouter({
  routes,
})

export default router
