class WhitelistsController < ApplicationController
  # load_and_authorize_resource

  # GET /whitelists
  def index
    authorize! :manage, User
    @permitted_users = User.all
  end

  # GET /whitelists/new
  def new
    @authorized_user = Whitelist.new(user_params)
  end

  # POST /whitelists/
  def create
    username = params[:username]
    if Whitelist.has_username?(username)
      flash[:notice] = "User #{username} already exists in whitelist. "
    else
      begin
        Whitelist.create!(username: username)
        flash[:notice] = "Add user #{username} successfully."
      rescue ActiveRecord::RecordInvalid
        flash[:notice] = "Invalid username format."
      end
    end
    redirect_to whitelists_path
  end

  # DELETE /whitelists/
  def destroy
    user = Whitelist.find(params[:id])
    if user.username.eql?(current_user.provider_username)
      flash[:notice] = "Delete yourself from the whitelist is not allowed. "
    else
      user.destroy!
      flash[:notice] = "User is deleted successfully."
    end
    redirect_to whitelists_path
  end

  def upgrade
    authorize! :manage, User
    unless current_user.role.eql?("admin") or current_user.role.eql?("instructor")
      flash[:alert] = "You do not have privilege to change other user's role. "
      redirect_to whitelists_path
      return
    end
    user = User.find(params[:id])
    if user.role.eql?("admin")
      flash[:alert] = "Admin role cannot be changed."
    end
    if user.role.eql?("student")
      user.change_role("instructor")
    end
    redirect_to whitelists_path
  end

  def downgrade
    authorize! :manage, User
    unless current_user.role.eql?("admin") or current_user.role.eql?("instructor")
      flash[:alert] = "You do not have privilege to change other user's role. "
      redirect_to whitelists_path
      return
    end
    user = User.find(params[:id])
    if user.role.eql?("admin")
      flash[:alert] = "Admin role cannot be changed."
    end
    if user.role.eql?("instructor")
      user.change_role("student")
    end
    redirect_to whitelists_path
  end

  private

  def user_params
    params.require(:whitelist).permit(:username)
  end
  
end
