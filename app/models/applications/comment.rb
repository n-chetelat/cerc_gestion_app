module Applications
  class Comment < ApplicationRecord

    self.table_name = "applications_comments"

    belongs_to :application, foreign_key: "application_id"
    belongs_to :author, class_name: "AdminUser"
    belongs_to :author_including_deleted, :class_name => "AdminUser", :foreign_key => 'author_id', :with_deleted => true

    validates :author_id, :content, presence: true
  end
end
