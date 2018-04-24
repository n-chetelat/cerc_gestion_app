<script>

import { mapGetters, mapActions } from "vuex"
import { focus } from "vue-focus"
import Vue from "vue"

import DatesMixin from "../../../../mixins/dates-mixin"

import { keyBy } from "lodash-es"

export default {
  name: "CommentsComponent",
  directives: { focus: focus },
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
      newCommentContent: "",
      editingComments: {}
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
      const that = this
      this.createComment(payload).then(() => {
        this.comments = this.commentsByApplication[this.application.id]
        this.newCommentContent = ""
        this.$emit("scroll")
      })
    },
    authorName(comment) {
      return (comment.author_is_current) ? "You" : comment.author_name
    },
    toggleEditable(comment) {
      if (!comment.author_is_current) return
      if (this.editingComments[comment.id]) {
        Vue.delete(this.editingComments, comment.id)
      } else {
        Vue.set(this.editingComments, comment.id, true)
      }
    },
    isEditingComment(comment) {
      return !!this.editingComments[comment.id]
    },
    async onEditContent(event, comment) {
      if (event.target.innerText === comment.content) return
      const payload = {applicationId: this.application.id,
        commentId: comment.id,
        params: {content: event.target.innerText}}
      await this.updateComment(payload).then(() => {
        this.comments = this.commentsByApplication[this.application.id]
      })
      this.toggleEditable(comment)
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
          span.comment-author(:class="{'author-current': comment.author_is_current}") {{authorName(comment)}}
          span.comment-timestamp on {{formattedDateTime(comment.created_at)}}
          button.comment-edit(v-if="comment.author_is_current", v-tooltip="'Edit comment'", @click="toggleEditable(comment)")
        div.comment-content(v-focus="isEditingComment(comment)", :contenteditable="isEditingComment(comment)", :class="{'--editing': isEditingComment(comment)}", @blur="onEditContent($event, comment)") {{comment.content}}
    div.new-comment
      textarea(v-model="newCommentContent", placeholder="Enter new comment...")
      button.submit.save-btn(type="button", @click="saveNewComment") Save



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
      background-color: var(--themeColor);
      display: inline-block;
      padding: 5px;
      border-radius: 2px;
      color: white;
      border: 1px solid gray(204);

      &.author-current {
        background-color: #00a6ff;
      }
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
      white-space: pre-wrap;
      &.--editing {
        background-color: gray(240);
      }
    }

    & .comment-edit {
    width: 25px;
    height: 25px;
    background: url("../../../../static/icons/pencil-charcoal.svg") center bottom / 60% no-repeat;
    padding: 0;
      &:hover {
        background: url("../../../../static/icons/pencil.svg") center bottom / 70% no-repeat;
      }
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
