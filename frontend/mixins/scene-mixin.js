export default {
  data() {
    return {
      loaded: false
    }
  },
  mounted() {
    this.$nextTick(() => {
      this.loaded = true
    })
  }
}
