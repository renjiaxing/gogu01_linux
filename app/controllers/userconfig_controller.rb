class UserconfigController < ApplicationController

  def show_code
    @code=Userconfig.find_by_name("code")
  end

  def update_code
    @code=Userconfig.find_by_name("code")
    @code.value=rand(900000)+100000
    if @code.save
      flash[:success] = "成功生成注册码!"
      redirect_to show_code_userconfig_index_path
    else
      flash[:alert] = "生成注册码失败!"
      redirect_to show_code_userconfig_index_path
    end
  end
end
