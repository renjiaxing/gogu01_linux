class Replyrelationship < ActiveRecord::Base
  belongs_to :replyuser,class_name: "User"
  belongs_to :replymicropost,class_name: "Micropost"
end
