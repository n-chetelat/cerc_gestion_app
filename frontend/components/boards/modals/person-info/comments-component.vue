<script>

import { mapGetters, mapActions } from "vuex"

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
      showError: false,
    }
  },
  computed: {
    ...mapGetters("comments", ["commentsByApplication"]),
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
        this.$emit("comment")
      }).catch((err) => {
        this.showError = true
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
    div(v-if="showError")
      p There has been an error when fetching this applicant's comments.
    div(v-else)
      comments-list-component(:application="application", @error="showError = true")
      div.new-comment
        textarea(v-model="newCommentContent", placeholder="Enter new comment...")
        button.submit.save-btn(type="button", @click="saveNewComment") Save
      hr
    keywords-component(:application="application")



</template>

<style>

@import "../../../../init/variables.css";

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
