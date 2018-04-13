class EmailInteractionError < StandardError

  def initialize(details)
    msg = "There was an error when communciating with email account: #{details}"
    super(msg)
  end
end
