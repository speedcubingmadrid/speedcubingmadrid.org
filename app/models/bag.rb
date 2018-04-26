class Bag < ApplicationRecord
  has_many :hardwares
  validates_presence_of :name
end
