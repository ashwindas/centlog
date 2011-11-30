class Alert < ActiveRecord::Base
  belongs_to :user

  validates :title, :presence => true
  validates :amount, :presence => true
  validates :date, :presence => true
  validates :user_id, :presence => true
  validates_numericality_of :amount, :only_integer => false, :message => "should be valid number."
  
end
