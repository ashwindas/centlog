class User < ActiveRecord::Base

  has_and_belongs_to_many :groups, :join_table => 'groups_users'

  has_many :transactions
  has_many :alerts

  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
                           
  has_many :following, :through => :relationships, :source => :followed
  
  
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me
  
  
    def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
  
    def feed
    Transaction.from_users_followed_by(self)
  end

end
