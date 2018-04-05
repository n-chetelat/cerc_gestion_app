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
    div.modal-backdrop(@click="close")
    div.modal-content
      header.modal-header
        span.modal-title
          slot(name="header")
        button.btn-close(type="button", @click="close")
      div.modal-body
        slot(name="body")

</template>

<style>

:root {
  --headerColor: #292929;
}

  .modal {
    z-index: 200;
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    display: flex;
    justify-content: center;
    align-items: center;

    & .modal-backdrop {
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      background-color: rgba(0, 0, 0, 0.3);
    }

    & .modal-content {
      z-index: 201;
      background: white;
      min-width: 200px;
      width: 80%;
      max-width: 900px;
      box-shadow: 2px 2px 20px 1px;
      border-radius: 2px;
      overflow-x: auto;
      display: flex;
      flex-direction: column;
    }

    & .modal-header {
      position: relative;
      color: var(--headerColor);
    }

    & .modal-body {
      position: relative;
      padding: 20px 10px;
    }

    & .modal-title {
      width: 90%;
      display: inline-block;
      padding: 0 15px;
    }

    & .btn-close {
      position: absolute;
      right: 0;
      top: 0;
      width: 3em;
      height: 3em;
      cursor: pointer;
      font-weight: bold;
      background: url("../../static/icons/x-charcoal.svg") center center no-repeat;
      margin: 10px;
    }

  }

</style>
