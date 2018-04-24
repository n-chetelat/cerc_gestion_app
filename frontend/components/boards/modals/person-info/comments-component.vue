<script>

import { mapGetters, mapActions } from "vuex"

import DatesMixin from "../../../../mixins/dates-mixin"

import { keyBy } from "lodash-es"

export default {
  name: "CommentsComponent",
  mixins: [DatesMixin],
  props: {
    application: {
      required: true
    },
  },
  async created() {
    if (!this.commentsByApplication[this.application.id]) {
      await this.fetchApplicationComments(this.application.id)
    }
    this.comments = this.commentsByApplication[this.application.id]
  },
  data() {
    return {
      comments: [],
      newCommentContent: ""
    }
  },
  computed: {
    ...mapGetters("comments", ["commentsByApplication"]),
  },
  methods: {
    ...mapActions("comments", ["fetchApplicationComments", "createComment", "updateComment"]),
    saveNewComment() {
      const payload = {applicationId: this.application.id,
        params: {content: this.newCommentContent}}
      this.createComment(payload).then(() => {
        this.comments = this.commentsByApplication[this.application.id]
      })
    }
  },
  components: {
  }
}
</script>

<template lang="pug">
  div.comments-component
    h2 Comments
    ul.comment-list(v-if="comments.length")
      li.comment-line(v-for="comment in comments")
        div.comment-header
          span.comment-timestamp By &nbsp;
          span.comment-author {{comment.author_name}}
          span.comment-timestamp on {{formattedDateTime(comment.created_at)}}
        div.comment-content {{comment.content}}
    div.new-comment
      textarea(v-model="newCommentContent", placeholder="Enter new comment...")
      button.submit.save-btn(type="button", @click="saveNewComment") Save



</template>

<style>

  :root {
    --textFamily: Helvetica, Arial, sans-serif;
    --textColor: gray(20);
  }

  .comments-component {
    width: 90%;
    margin: auto;

    & .comment-list {
      margin-bottom: 4em;
    }

    & .comment-line {
      padding: 5px;
      box-shadow: -2px 2px 6px rgba(0, 0, 0, .5);
      margin-bottom: 1em;
      background-color: gray(230);
      border-radius: 3px;
    }

    & .comment-header {
      padding: 3px 15px;
      text-align: right;
    }

    & .comment-author {
      font-size: .8em;
      font-weight: bold;
      background-color: beige;
      display: inline-block;
      padding: 5px;
      border-radius: 2px;
      color: gray(153);
      border: 1px solid gray(204);
    }
    & .comment-timestamp {
      display: inline-block;
      font-size: .7em;
      margin-left: 5px;
      color: gray(90);
    }
    & .comment-content {
      width: 90%;
      padding: 1.5em;
      border: 1px solid transparent;
      border-radius: 3px;
      margin: 3px auto 10px auto;
      background-color: white;
      box-shadow: -1px 1px 6px rgba(0, 0, 0, .5);
      font-family: var(--textFamily);
      color: var(--textColor);
      font-size: .9em;
      line-height: 1.5em;
    }

    & .new-comment {
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
  }

</style>
