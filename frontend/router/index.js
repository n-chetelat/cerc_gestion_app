import Vue from 'vue'
import VueRouter from 'vue-router'

import axios from "axios"

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

function AuthGuard(to, from, next) {
  if (!to.path.startsWith("/admin/")) next()
  else {
    const url = `${process.env.RAILS_HOST}/en/api/users/auth`
    axios.get(url).then(({ data }) => {
      if (data.authorized) {
        next()
      } else {
        window.location = "/admin/login"
      }
    })
  }
}

const router = new VueRouter({
  routes,
})

router.beforeEach(AuthGuard)

export default router
