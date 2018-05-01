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

function sendMessage(message) {
  board.perforn("send_status_message", { message })
}

function setCallback(fn) {
  callback = fn
}

export { sendMessage, getParticipantInfo, setCallback }
