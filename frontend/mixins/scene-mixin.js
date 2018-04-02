import LoadingScreen from '../components/shared/loading-screen.vue'

export default {
  data() {
    return {
      loading: false,
      loaded: false,
    }
  },
  mounted() {
    this.$nextTick(() => {
      this.loaded = true
    })
  },
  components: {
    LoadingScreen
  }
}
