class Unreadmsg < ActiveRecord::Base
  belongs_to :msgfrom,class_name: "User"
  belongs_to :msgto,class_name: "User"
end
