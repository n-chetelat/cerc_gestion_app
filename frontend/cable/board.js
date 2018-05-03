import createChannel from "cable/cable"

let callback
let commentsCallback

const board = createChannel("BoardChannel",  {
  received(data) {
    if (data.refresh_comments && commentsCallback) {
      commentsCallback.call(null, data)
    }
    else if (callback) callback.call(null, data)
  }
})

function getParticipantInfo() {
  board.perform("send_participant_info")
}

function sendStatusMessage(type, params) {
  board.perform("send_status_message", { type, params })
}

function setCallback(fn) {
  callback = fn
}

function setCommentsCallback(fn) {
  commentsCallback = fn
}

export {
  sendStatusMessage,
  getParticipantInfo,
  setCallback,
  setCommentsCallback }
