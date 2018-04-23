class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_paranoid

  def full_name
    [self.name, self.lastname].map(&:presence)
      .compact.join(" ")
  end
  
end
