json.extract! comment, :id, :content, :application_id, :created_at
json.author_name comment.author_including_deleted.full_name
json.author_deleted !!comment.author_including_deleted.deleted_at
