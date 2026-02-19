# app/models/group.rb
class Group < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :name, presence: true
end
