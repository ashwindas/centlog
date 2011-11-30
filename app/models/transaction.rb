class Transaction < ActiveRecord::Base
  belongs_to :user

  validates :description, :presence => true
  validates :amount, :presence => true
  validates :tag, :presence => true
  validates :date, :presence => true
  validates_numericality_of :amount, :only_integer => false, :message => "should be valid number."

  attr_accessible :user_id, :description, :amount, :tag, :date

  default_scope :order => 'transactions.date DESC'

  # Return microposts from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private
  # Return an SQL condition for users followed by the given user.
  # We include the user's own id as well.
  def self.followed_by(user)
    following_ids = %(SELECT followed_id FROM relationships
    WHERE follower_id = :user_id)
    where("user_id IN (#{following_ids})",
    { :user_id => user })
  end

end
