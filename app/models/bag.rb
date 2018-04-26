class Bag < ApplicationRecord
  include HasOwners
  has_many :hardwares
  validates_presence_of :name
end
