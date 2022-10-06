class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def initialize
    @roles = ['employee', 'admin']
  end
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
    respond_to do |format|
      if @user.save
        update_user_role(@user, params[:user][:roles])
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        update_user_role(@user, params[:user][:roles])
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  def delete_batch_action
    User.find(params[:batch_action_ids]).each(&:destroy)
    redirect_to :admin_users, notice: "Successfully deleted #{params[:batch_action_ids].size} users"
  end


  def update_user_role(user, roles = [])
    user.roles.destroy_all if user.roles.present?
    roles.each do |role|
      if role === 'employee'
        user.add_role :employee
      elsif role === 'admin'
        user.add_role :admin
      end
    end
  end

  def delete_user_by_selection
    user_ids = params[:user_ids]
    if user_ids.present? && user_ids === 'all'
      User.destroy_all
      elsif user_ids.present? && user_ids.present?
      User.where(id: user_ids).destroy_all
    end
    render json: { success: true, message: 'Successfully deleted' }, status: 200
  rescue => e
    render json: { message: e.message }, status: 400
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
      params.require(:user).permit(:name, :email, :phone_number, :dob, :active)
    end
end
