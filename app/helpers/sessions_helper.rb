module SessionsHelper

  def current_user=(user)
    @current_user = user
  end

  def current_user
    if session[:user]
      @current_user ||= User.find(session[:user])
    elsif cookies[:remember_token]
      @current_user ||= User.find_by_remember_token!(cookies[:remember_token])
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def session_create(user_id)
    session[:user] = user_id
  end

  def session_destroy
    session[:user] = nil
  end

end