class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_paranoid

  validates :email, :name, :lastname, presence: true
  validates :email, uniqueness: true

  def full_name
    [self.name, self.lastname].map(&:presence)
      .compact.join(" ")
  end


end
