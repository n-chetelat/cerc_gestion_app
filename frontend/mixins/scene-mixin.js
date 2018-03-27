
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
}
