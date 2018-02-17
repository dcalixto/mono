class SessionsController < ApplicationController

  def new
    redirect_to root_url if current_user
  end

  def create
  
    user = User.authenticate(params[:username_or_email],params[:password])
    if user
     
      user.update_attribute(:login_at, Time.zone.now)
      user.update_attribute(:ip_address, request.remote_ip)
      session[:user_id] = user.id
      redirect_to '/'

    elsif self.request.format.json?

      @data = File.read('/home/daniel/puppy/public/login.json')
      @data = @data.gsub(/ROOT/, root_url)
      render :json => @data

      #allow_token_to_be_used_only_for(user)
      # send_auth_token_for_login_of(user)
      #redirect_to '/'

    else
      # If user's login doesn't work, send them back to the login form.
      redirect_to '/login', notice:  "Email, Username or password invalid"

    end

  end


  def destroy

    session[:user_id] = nil
    redirect_to '/login'
  end


  private

  def send_auth_token_for_login_of(user)
    render json: { auth_token: user.auth_token }
  end

  # def allow_token_to_be_used_only_for(user)
  #  user.regenerate_token
  #end



end
