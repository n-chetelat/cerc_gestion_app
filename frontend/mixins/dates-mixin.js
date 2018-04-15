import * as moment from "moment"

export default {
  methods: {
    formattedDate(timestamp) {
      const date = moment(timestamp)
      return date.format("MMMM Do YYYY")
    },
    formattedDateTime(timestamp) {
      const date = moment(timestamp)
      return date.format("MMMM Do YYYY [at] h:mm:ss a")
    },
  }
}
