class Stock < ActiveRecord::Base
  has_many :microposts
  has_many :mystocks
end
