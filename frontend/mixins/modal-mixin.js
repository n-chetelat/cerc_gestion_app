
export default {
  data() {
    return {
      modalName: null,
      modalVisible: false,
    }
  },
  methods: {
    openModal(name) {
      this.modalName = name
      this.modalVisible = true
    },
    closeModal() {
      this.modalVisible = false
      this.modalName = null
    },
  }
}
