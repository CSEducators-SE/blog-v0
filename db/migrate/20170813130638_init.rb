class Init < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |i|
      i.integer :se_id
      i.text :token
      i.text :session
    end
    create_table :posts do |i|
      i.integer :user_id
      i.text :title
      i.text :body
      i.datetime :created_at
    end
    create_table :comments do |i|
      i.integer :user_id
      i.integer :post_id
      i.text :content
      i.datetime :created_at
    end
  end
end
