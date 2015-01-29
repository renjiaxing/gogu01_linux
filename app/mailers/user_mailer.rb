class UserMailer < ActionMailer::Base
  default from: "ren_jiaxing1984@163.com"

  def send_confirmation_mail(user)
    @user = user
    mail(to: @user.email, subject: '用户注册确认')
  end

  def send_password_reset_mail(user)
    @user = user
    mail(to: user.email, subject: '密码重置')
  end
end
