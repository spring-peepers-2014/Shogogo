class UsersController < ApplicationController
  include ApplicationHelper
  def new
    render :partial => 'register_form'
  end

  def create
    @user = User.find(session[:user_id])
    @user.update(phone_number: params[:user][:phone_number], name: params[:user][:name])
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password]
    @user.longitude = 40.77 
    @user.latitude = -73.98
    @user.guest = false
    
    if @user.save
    
    # flash[:notice] = "Successfully registered."
      send_sms(@user.phone_number, "Thank you for using Shogogo! Reply 'confirm' to verify your number or reply 'stop' to unsubscribe.")
      sleep(10)
      render :json => { :status => 'ok', :message => 'Success!'}
    else
      render :json => { :errors => @model.errors.full_messages }
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone_number, :password, :name)
  end
end
