class Person < ApplicationRecord

  validates :name, :lastname, :email, presence: true
  validate :validate_email_format

  def validate_email_format
    unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      errors.add(:email, "is not email")
    end
  end

end
