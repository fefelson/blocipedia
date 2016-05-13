class Wiki < ActiveRecord::Base
  belongs_to :user


  validates :title, length: {minimum: 5}, presence: true
  validates :body, length: {minimum: 15}, presence: true


  def public!
    puts "here"
    update_attribute(:pravate, false)
  end

end
