module Gogu
  class API < Grape::API
    prefix "api"
    format :json

    get "version" do
      @user=User.find(1)
    end

  end
end