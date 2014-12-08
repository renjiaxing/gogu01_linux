class Pmsg < ActiveRecord::Base

  belongs_to :fromuser,class_name: "User"
  belongs_to :touser,class_name: "User"

end
