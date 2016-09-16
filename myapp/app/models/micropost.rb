class Micropost < ActiveRecord::Base
  belongs_to :users
  validates :content, length:{maximum:140},
      presence: true
end
