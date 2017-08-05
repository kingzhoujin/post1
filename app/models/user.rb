class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
  def display_name
    # # 取 email 的前半来显示，如果你也可以另开一个字段nickname让用户可以自己编辑显示名称
    self.email.split("@").first
  end

  has_many :likes, :dependent => :destroy
  has_many :liked_posts, :through => :likes, :source => :post
end
