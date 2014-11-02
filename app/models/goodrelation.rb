class Goodrelation < ActiveRecord::Base
  belongs_to :good ,class_name: "User"
  belongs_to :begood ,class_name: "Micropost"
end
