<script>

import { mapActions } from "vuex"

import CommentsListComponent from "./comment-list-component.vue"
import KeywordsComponent from "./keywords-component.vue"

import { keyBy } from "lodash-es"

export default {
  name: "CommentsComponent",
  props: {
    application: {
      required: true
    },
  },
  data() {
    return {
      newCommentContent: "",
    }
  },
  computed: {
  },
  methods: {
    ...mapActions("comments", ["createComment"]),
    saveNewComment() {
      const payload = {applicationId: this.application.id,
        params: {content: this.newCommentContent}}
      const that = this
      this.createComment(payload).then(() => {
        this.comments = this.commentsByApplication[this.application.id]
        this.newCommentContent = ""
      })
    },
  },
  components: {
    KeywordsComponent,
    CommentsListComponent
  }
}
</script>

<template lang="pug">
  div.comments-component
    comments-list-component(:application="application")
    div.new-comment
      textarea(v-model="newCommentContent", placeholder="Enter new comment...")
      button.submit.save-btn(type="button", @click="saveNewComment") Save
    hr
    keywords-component(:application="application")



</template>

<style>

  :root {
    --textFamily: 'Open Sans', Arial, sans-serif;
    --textColor: gray(20);
    --themeColor: #00a668;
  }

  .comments-component {
    width: 90%;
    margin: auto;

    & hr {
      color: var(--textColor);
      margin: 3em auto;
    }

    & .new-comment {
      margin-top: 2em;
      & textarea {
        display: block;
        width: 100%;
        margin: auto;
        padding: 1.5em;
        font-family: var(--textFamily);
        color: var(--textColor);
      }
      & .save-btn {
        display: block;
        width: 50%;
        margin: auto;
        margin-top: 10px;
      }
    }

    & .margin-bottom {
      margin-bottom: 2em;
    }
  }

</style>
