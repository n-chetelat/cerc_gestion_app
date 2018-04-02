class GmailOauthError < StandardError

  def initialize(msg="The application needs permission to access Gmail account.")
    super
  end
end
