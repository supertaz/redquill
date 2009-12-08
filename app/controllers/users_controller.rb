class UsersController < ApplicationController
  caches_page :show
  cache_sweeper :post_sweeper, :only => [:create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.attributes = params[:user]
    if verify_recaptcha(:model => @user, :message => 'Oops!  Did you get those verification words right?') && @user.save
      flash[:notice] = "Successfully updated your profile."
      render :action => 'show'
    else
      render :action => 'edit'
    end
  end

  def email
    @user = User.find_by_username(params[:user_id])
    if request.method == :post
      if verify_recaptcha
        if current_user
          UserMailer.deliver_user_contact(@user, current_user, params[:subject], params[:note])
        else
          UserMailer.deliver_non_user_contact(@user, params[:sender_name], params[:sender_email], params[:subject], params[:note])
        end
        redirect_to show_posts_url(:year => 'all')
      else
        @sender_name = params[:sender_name]
        @sender_email = params[:sender_email]
        @subject = params[:subject]
        @note = params[:note]
        render :action => 'email'
      end
    end
  end

  def show
    @user = User.find_by_username(params[:id])
  end
end
