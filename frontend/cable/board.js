import createChannel from "cable/cable"

let callback

const board = createChannel("BoardChannel",  {
  received({ user }) {
    if (callback) callback.call(null, user)
  }
})

function sendUserInfo() {
  board.perform("send_user_info")
}

function setCallback(fn) {
  callback = fn
}

export { sendUserInfo, setCallback }
