<script>

import { mapGetters, mapActions } from "vuex"

import { keyBy } from "lodash-es"

export default {
  name: "CommentsComponent",
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
    ul.comment-list
      li.comment-line(v-for="comment in comments")
        div {{comment.author_name}}
        div {{comment.content}}
        div {{comment.created_at}}
    div.new-comment
      textarea(v-model="newCommentContent", placeholder="Enter new comment")
      button(type="button", @click="saveNewComment") Save



</template>

<style>


  .comments-component {
  }

</style>
