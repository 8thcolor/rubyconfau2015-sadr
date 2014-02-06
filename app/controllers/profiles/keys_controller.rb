class Profiles::KeysController < ApplicationController
  layout "profile"
  skip_before_filter :authenticate_user!, only: [:get_keys]

  def index
    @keys = current_user.keys.order('id DESC')
  end

  def show
    @key = current_user.keys.find(params[:id])
  end

  def new
    @key = current_user.keys.new
  end

  def create
    @key = current_user.keys.new(params[:key])

    if @key.save
      redirect_to profile_key_path(@key)
    else
      render 'new'
    end
  end

  def destroy
    @key = current_user.keys.find(params[:id])
    @key.destroy

    respond_to do |format|
      format.html { redirect_to profile_keys_url }
      format.js { render nothing: true }
    end
  end

  #get all keys of a user(params[:username]) in a text format
  #helpful for sysadmins to put in respective servers
  def get_keys
    if params[:username].present?
      begin
        user = User.find_by_username(params[:username])
        user.present? ? (render :text => user.all_ssh_keys.join('\n')) :
          (render_404 and return)
      rescue => e
        render text: e.message
      end
    else
      render_404 and return
    end
  end

end
