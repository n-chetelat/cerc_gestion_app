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
  div.loading
    div.loading-backdrop
    div.loading-content


</template>

<style>

  .loading {
    z-index: 200;
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    display: flex;
    justify-content: center;
    align-items: center;

    & .loading-backdrop {
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      background-color: rgba(0, 0, 0, 0.3);
    }

    & .loading-content {
      z-index: 201;
      background: url("../../static/images/spinner.gif") center center / 70% no-repeat white;
      border-radius: 20px;
      height: 200px;
      width: 200px;
      box-shadow: 0 0 20px 2px black;
    }

  }

</style>
