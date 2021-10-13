# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: %i[destroy]

  def new; end

  def create
    # render plain: params.to_yaml and return # временная заглушка для просмотра params
    user = User.find_by email: params[:email] # @ не нужна т.к. эта переменная
    # не будет использоваться в отображениях views
    if user&.authenticate(params[:password])
      # метод authenticate добавился из
      # has_secure_password, & нужен если user будет nil, тогда условие if
      # обратится в ложное и мы перейдем в else без выброса ошибки,
      # т.к. nil.authenticate вызовет nomethoderror
      do_sign_in user
    else
      flash[:warning] = 'incorrect email and/or password'
      render :new
    end
  end

  def destroy
    sign_out
    flash[:success] = 'See you later'
    redirect_to root_path
  end

  private

  def do_sign_in(user)
    sign_in user
    remember(user) if params[:remember_me] == '1'
    flash[:success] = "Welcome back, #{current_user.name_or_email}!"
    redirect_to root_path
  end
end
