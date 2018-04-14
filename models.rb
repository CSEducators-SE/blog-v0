class User < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :user
end

class Comment < ActiveRecord::Base
  belongs_to :post
end
