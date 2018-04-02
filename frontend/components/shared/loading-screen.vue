<script>

export default {
  name: "LoadingScreen",
  data() {
    return {
    }
  },
}
</script>

<template lang="pug">
  div.modal
    div.modal-backdrop
    //- div.modal-content


</template>

<style>

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

  }

</style>
