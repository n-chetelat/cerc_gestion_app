module Uuid
  extend ActiveSupport::Concern

  included do
    before_validation :set_uuid, if: Proc.new {|resource| resource.uuid.nil? }
    validates :uuid, presence: true
  end

  def set_uuid
    return if self.uuid.present?
    uuid = SecureRandom.uuid
    loop do
      break unless self.class.exists?(uuid: uuid)
      uuid = SecureRandom.uuid
    end
    self.uuid = uuid
  end

  module ClassMethods
  end
end
