class RegistrationController < ApplicationController
  def register

  end

  def register_user
    if params.has_key?(:username) && !params[:username].strip.empty?
      # TODO: check for duplicate username

      user = User.find_by_username(params[:username])
      if user.nil?
        user1 = User.new
        # add user input to user1 variable
        user1.firstname = params[:firstname] unless params[:firstname].empty?
        user1.lastname = params[:lastname] unless params[:lastname].empty?
        user1.streetaddr = params[:streetaddr] unless params[:streetaddr].empty?
        user1.city = params[:city] unless params[:city].empty?
        user1.city = params[:state] unless params[:state].empty?
        user1.city = params[:zipcode] unless params[:zipcode].empty?
        user1.city = params[:country] unless params[:country].empty?
        user1.username = params[:username]
        user1.password = params[:password]
        user1.save
        # add phone to user
        add_phone(user1, params[:phone1])
        add_phone(user1, params[:phone2])
        add_phone(user1, params[:phone3])
        # save userid to cookies for tracking user session
        cookies[:userid] = user1.id
        redirect_to '/registration/user_info'
      else
        redirect_to '/registration/register'
        flash[:notice] = "User ID taken, try another."
      end
    else
      # stay on the same page if no username input
        render '/registration/register'
    end
  end

  # add phone to user table
  def add_phone(user, phonenumber)
    phone1 = Phone.new
    !phonenumber.empty? ? phone1.phonenumber = phonenumber : phone1.phonenumber = "No Phone"
    user.phones << phone1
  end

  def user_info
    # get user record using userid from cookies
    if !cookies[:userid].nil?
      @user = User.find(cookies[:userid])
    else
      flash[:notice] = "Please Log In to view User Info"
      redirect_to '/registration/login'
    end
  end

  def login
  end

  def login_user
    if params.has_key?(:username) && !params[:username].strip.empty? && params.has_key?(:password) && !params[:password].strip.empty?
      user = User.find_by_username(params[:username])
      if user.nil?
        flash[:alert] = "Log in failed, try again; Wrong Username"
        render 'login'
      else
        if user.password == params[:password]
          cookies[:userid] = user.id
          redirect_to '/registration/user_info'
        else
          render 'login'
          flash[:alert] = "Log in failed, try again; Wrong Password"
        end
      end
    end
  end

  def logout
    cookies.delete :userid
    flash[:notice] = "You are now logged out"
    redirect_to '/registration/login'
  end
end
