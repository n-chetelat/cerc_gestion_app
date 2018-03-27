<script>

export default {
  name: "Modal",
  data() {
    return {
    }
  },
  computed: {
  },
  methods: {
    close() {
      this.$emit("close")
    }
  }
}
</script>

<template lang="pug">
  div.modal
    div.modal-backdrop
      div.modal-content
        header.modal-header
          button.btn-close(type="button", @click="close") x
        div.modal-body
          slot(name="body")

</template>

<style>

  .modal {

    & .modal-backdrop {
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      background-color: rgba(0, 0, 0, 0.3);
      display: flex;
      justify-content: center;
      align-items: center;
    }

    & .modal-content {
      background: white;
      min-width: 200px;
      width: 80%;
      max-width: 900px;
      box-shadow: 2px 2px 20px 1px;
      overflow-x: auto;
      display: flex;
      flex-direction: column;
    }

    & .modal-body {
      position: relative;
      padding: 20px 10px;
    }

    & .btn-close {
      border: none;
      border-radius: 50%;
      font-size: 20px;
      width: 2em;
      height: 2em;
      cursor: pointer;
      font-weight: bold;
      line-height: 0;
      color: white;
      background: black;
      float: right;
      margin: 4px;
    }

  }

</style>
