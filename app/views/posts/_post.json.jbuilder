json.extract! post, :id, :title, :body, :slug, :feature, :user_id, :draft, :competition_page, :created_at, :updated_at
json.url post_url(post, format: :json)
