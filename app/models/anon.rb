class Anon < ActiveRecord::Base

  belongs_to :anonuser,class_name: "User"
  belongs_to :anonmicropost,class_name: "Micropost"

end
