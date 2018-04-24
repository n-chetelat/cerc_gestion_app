json.extract! comment, :id, :content, :application_id, :created_at
json.author_name comment.author_including_deleted.full_name
json.author_is_current comment.author_id === @current_admin_user_id
