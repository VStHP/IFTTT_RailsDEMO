class AddColumnToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :link_to_post, :string
  end
end
