<script>
import { mapGetters, mapActions } from 'vuex'

  export default {
    name: "RecruitmentForm",
    data() {
      return {
        application: {
          position: null
        },
        positions: []
      }
    },
    async created() {
      await this.getAllPositions()
      this.positions = this.allPositions
    },
    computed: {
      ...mapGetters(["allPositions"])
    },
    methods: {
      ...mapActions(["getAllPositions"])
    }
  }
  </script>

  <template lang="pug">
    div.recruitment-form
      div.information
        h1 Application Form
        p Our lab aims to combine mathematical optimization and machine learning. For moreinformation, please visit our website and see our recent publications. For allpositions, our ideal candidate has strong backgrounds in both mathematics andcomputer science, with experience in large-scale data analysis.
        p We expect applicants to have a reasonable knowledge of English. In addition,Montreal is a primarily French-speaking environment and Polytechnique Montrealcourses are usually given in French, so we expect applicants to either have a workingknowledge of French or be willing to learn it.
        p If you are admitted to a student position, our offer will include a generous financialhelp package that covers tuition costs, as well as provide a comfortable stipend forliving. In addition, these offers are not typically contigent on any teachingobligations.
      div.application-form
        form
          div.form-row.position-select
            label.label Which position are you applying for?
            select(v-model="application.position")
              option(value="null") Select a position
              option(v-for="position in positions", :value="position.id") {{position.title}}
          div.position-fields
            div.form-row
              label.label Name
              input(type="text")
            div.form-row
              label.label Name
              input(type="text")
  </template>

  <style scoped>
    .information h1 {
      text-align: center;
    }

    .information p {
      line-height: 1.4em;
      margin: 15px 10%;
    }

    .application-form {
      width: 90%;
      margin: auto;
      border-top: 2px solid black;
      padding-top: 20px;
    }

    .position-fields .form-row {
      margin: 10px auto;
    }

    .application-form .label {
      display: inline-block;
      width: 30%;
      margin-right: 10px;
      vertical-align: top;
      text-align: right;
    }

    .application-form input[type="text"] {
      width: 20em;
    }

    .position-select {
      padding-bottom: 20px;
    }

    .position-select select {
      display: inline-block;
      padding: .7em;
      width: 20em;
      background-color: white;
    }

  </style>
