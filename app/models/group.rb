class Group < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => 'groups_users'

  attr_accessible :name, :description, :owner_id

  validates :name, :presence => true, :uniqueness => true
  validates :description, :presence => true
  validates :owner_id, :presence => true

end
