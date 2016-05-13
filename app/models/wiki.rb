class Wiki < ActiveRecord::Base
  belongs_to :user

  attr_accessor :params_private, :private

  validates :title, length: {minimum: 5}, presence: true
  validates :body, length: {minimum: 15}, presence: true
  
  def private?
    self.private
  end
  
  def public?
    !private?
  end

  def public!
    self.private = false
   end
end
