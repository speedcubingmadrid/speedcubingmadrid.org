class AddPostedAtToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :posted_at, :date
    Post.update_all("posted_at = created_at")
  end
end
