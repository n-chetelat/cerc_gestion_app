
export default {
  data() {
    return {
      loading: false,
      loaded: false,
      modalVisible: false,
      modalName: null,
    }
  },
  mounted() {
    this.$nextTick(() => {
      this.loaded = true
    })
  },
  methods: {
    openModal(modalName) {
      this.modalName = modalName
      this.modalVisible = true
    },
    closeModal() {
      this.modalVisible = false
      this.modalName = null
    }
  },
}
