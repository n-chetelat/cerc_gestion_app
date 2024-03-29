<script>
import { setCommentsCallback } from "cable/board"

import { mapGetters, mapActions } from "vuex"
import { focus } from "vue-focus"
import Vue from "vue"

import DatesMixin from "../../../../mixins/dates-mixin"

import { keyBy } from "lodash-es"

export default {
  name: "CommentsListComponent",
  directives: { focus: focus },
  mixins: [DatesMixin],
  props: {
    application: {
      required: true
    },
  },
  beforeCreate() {
    setCommentsCallback((data) => {
      this.fetchApplicationComments(this.application.id).then(() => {
        this.comments = this.commentsByApplication[this.application.id]
      })
    })
  },
  async created() {
    try {
      if (!this.commentsByApplication[this.application.id]) {
        await this.fetchApplicationComments(this.application.id)
      }
      this.comments = this.commentsByApplication[this.application.id]
    } catch(err) {
      this.$emit("error")
    }
  },
  data() {
    return {
      comments: [],
      editingComments: {},
    }
  },
  computed: {
    ...mapGetters("comments", ["commentsByApplication"]),
    hasComments() {
      return this.comments && this.comments.length
    },
  },
  methods: {
    ...mapActions("comments", ["fetchApplicationComments", "updateComment"]),
    authorName(comment) {
      return (comment.author_is_current) ? "You" : comment.author_name
    },
    toggleEditable(comment) {
      if (!comment.author_is_current) return
      Vue.set(this.editingComments, comment.id, true)
    },
    isEditingComment(comment) {
      return !!this.editingComments[comment.id]
    },
    async onEditContent(event, comment) {
      if (event.target.innerText === comment.content) {
        Vue.delete(this.editingComments, comment.id)
        return
      }
      const payload = {applicationId: this.application.id,
        commentId: comment.id,
        params: {content: event.target.innerText}}
      try {
        await this.updateComment(payload).then(() => {
          this.comments = this.commentsByApplication[this.application.id]
        })
        Vue.delete(this.editingComments, comment.id)
      } catch(err) {
        this.$emit("error")
      }
    },
  },
}
</script>

<template lang="pug">
  div.comment-list-component
    h2 Comments
    ul.comment-list(v-if="hasComments")
      li.comment-line(v-for="comment in comments")
        div.comment-header
          span.comment-timestamp By &nbsp;
          span.comment-author(:class="{'author-current': comment.author_is_current}") {{authorName(comment)}}
          span.comment-timestamp on {{formattedDateTime(comment.created_at)}}
          button.comment-edit(v-if="comment.author_is_current", v-tooltip="'Edit comment'", @click="toggleEditable(comment)")
        div.comment-content(v-focus="isEditingComment(comment)", :contenteditable="isEditingComment(comment)", :class="{'--editing': isEditingComment(comment)}", @blur="onEditContent($event, comment)") {{comment.content}}



</template>

<style>

@import "../../../../init/variables.css";

  .comment-list-component {

    & .comment-list {
      margin-bottom: 1em;
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
  }

</style>
