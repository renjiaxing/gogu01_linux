class Unreadrelation < ActiveRecord::Base
  belongs_to :unreaduser,class_name: "User"
  belongs_to :unreadmicropost,class_name: "Micropost"
end
