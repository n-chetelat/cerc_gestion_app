module Taggable
  extend ActiveSupport::Concern

  included do
    acts_as_taggable_on :keywords
  end

  module ClassMethods
  end
end
