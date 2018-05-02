import createChannel from "cable/cable"

let callback

const board = createChannel("BoardChannel",  {
  received(data) {
    if (callback) callback.call(null, data)
  }
})

function getParticipantInfo() {
  board.perform("send_participant_info")
}

function sendStatusMessage(type) {
  board.perforn("send_status_message", { type })
}

function setCallback(fn) {
  callback = fn
}

export { sendStatusMessage, getParticipantInfo, setCallback }
