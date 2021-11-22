class UsersController < ApplicationController
include Verify
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    if valid_phone_number?(user_params['country_code'], user_params['phone_number'])
      @user.save
      redirect_to @user, notice: 'You have a valid phone number!'
    else
      flash.alert = 'Please enter a valid phone number'
      render :new
    end
    
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    
      if  valid_confirmation_code?(params['code'], @user.country_code, @user.phone_number)
        @user.update(verified: true)
        redirect_to users_path, notice: "#{@user.phone_number} has been verified!"
      else
        redirect_to @user, alert: 'invalid or expired token'
      end
    end
  

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :country_code, :phone_number)
    end

    def valid_confirmation_code?(code, country_code, phone_number)
      response = Authy::PhoneVerification.check(verification_code: code, country_code: country_code, phone_number: phone_number)
      response.success?
    end
  
end


