class UsersController < ApplicationController

  def index
  end

  def show
  end

  def new
    @user = User.new
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id

        format.html { redirect_to '/', notice: 'User created.' }
        format.json { redirect_to '/', status: :created }

        elsif self.request.format.json?    

          @data = File.read('/home/daniel/puppy/public/login.json')
          @data = @data.gsub(/ROOT/, root_url)
          render :json => @data
          

      else
        format.html { redirect_to '/signup', error: "Something Went Wrong." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end




  def edit
  end


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @current_user.update(user_params)
        format.html { redirect_to @current_user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @current_user.destroy
    respond_to do |format|
      format.html { redirect_to login_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private


  def user_params
    params.require(:user).permit(:name,:username, :email, :password, :password_confirmation)
  end

end
