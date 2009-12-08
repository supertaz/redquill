class PostsController < ApplicationController
  caches_page   :index, :new, :show, :tag
  cache_sweeper :post_sweeper, :only => [:create, :update, :delete]

  before_filter :require_user, :only => [:new, :edit, :create, :update]

  def index
    redirect_to show_posts_url(:year => 'all')
  end

  def new
    if current_user && (current_user.is_poster? || current_user.is_admin?) then
      @post = Post.new()
      render '_form'
    else
      redirect_to show_posts_url(:year => 'all')
    end
  end

  def create
    if current_user && (current_user.is_poster? || current_user.is_admin?)
      @post = Post.create(params[:post])
      @post.poster = current_user
      if @post.save
        redirect_to show_posts_url(:year => @post.created_at.year, :month => @post.created_at.month, :day => @post.created_at.day, :slug => @post.slug)
      else
        render '_form'
      end
    else
      redirect_to show_posts_url(:year => @post.created_at.year, :month => @post.created_at.month, :day => @post.created_at.day, :slug => @post.slug)
    end
  end

  def edit
    @post = Post.find(params[:id])
    if current_user
      if @post.poster.id == current_user.id
        render '_form'
      else
        redirect_to show_posts_url(:year => @post.created_at.year, :month => @post.created_at.month, :day => @post.created_at.day, :slug => @post.slug)
      end
    else
      redirect_to show_posts_url(:year => @post.created_at.year, :month => @post.created_at.month, :day => @post.created_at.day, :slug => @post.slug)
    end
  end

  def update
    @post = Post.find(params[:id])
    if current_user
      if @post.poster.id = current_user.id && @post.update_attributes(params[:post])
        redirect_to show_posts_url(:year => @post.created_at.year, :month => @post.created_at.month, :day => @post.created_at.day, :slug => @post.slug)
      elsif @post.poster.id = current_user.id
        render 'edit'
      else
        redirect_to show_posts_url(:year => @post.created_at.year, :month => @post.created_at.month, :day => @post.created_at.day, :slug => @post.slug)
      end
    else
      redirect_to show_posts_url(:year => @post.created_at.year, :month => @post.created_at.month, :day => @post.created_at.day, :slug => @post.slug)
    end
  end

  def show
    if params[:year] == 'all'
      @posts = Post.by_age.paginate(:page => params[:page], :per_page => 5)
      render 'list'
    else
      unless params[:slug].nil? || params[:day].nil?|| params[:month].nil? || params[:year].nil?
        posts = Post.by_slug_and_date(params[:slug], params[:year], params[:month], params[:day]).paginate(:page => params[:page], :per_page => 5)
        if posts.length > 1
          @posts = posts
          render 'list'
        else
          @post = posts[0]
        end
      else
        if params[:slug].nil? && !params[:day].nil? && !params[:month].nil? && !params[:year].nil?
          posts = Post.by_date(params[:year], params[:month], params[:day]).paginate(:page => params[:page], :per_page => 5)
          if posts.length > 1
            @posts = posts
            render 'list'
          else
            @post = posts[0]
          end
        elsif params[:slug].nil? && params[:day].nil? && !params[:month].nil? && !params[:year].nil?
          posts = Post.by_month(params[:year], params[:month]).paginate(:page => params[:page], :per_page => 5)
          if posts.length > 1
            @posts = posts
            render 'list'
          else
            @post = posts[0]
          end
        elsif params[:slug].nil? && params[:day].nil? && params[:month].nil? && !params[:year].nil?
          posts = Post.by_year(params[:year]).paginate(:page => params[:page], :per_page => 5)
          if posts.length > 1
            @posts = posts
            render 'list'
          else
            @post = posts[0]
          end
        else
          redirect_to show_posts_url(:year => 'all')
        end
      end
    end
  end

  def delete
    @post = Post.find(params[:id])
    if current_user then
      if @post.poster == current_user || current_user.is_admin?
        @post.destroy
      else
        redirect_to show_posts_url(:year => @post.created_at.year, :month => @post.created_at.month, :day => @post.created_at.day, :slug => @post.slug)
      end
      redirect_to show_posts_url(:year => 'all')
    else
      redirect_to show_posts_url(:year => @post.created_at.year, :month => @post.created_at.month, :day => @post.created_at.day, :slug => @post.slug)
    end
  end

  def tag
    @tag = params[:tag_name]
    @posts = Post.tagged_with(@tag).by_age.paginate(:page => params[:page], :per_page => 5)
  end

  def email
    @post = Post.find(params[:post_id])
    if request.method == :post
      if verify_recaptcha
        PostMailer.deliver_share_post(@post,
                                      current_user ? current_user.firstname : Sanitize.clean(params[:sender_first_name]),
                                      current_user ? current_user.lastname : Sanitize.clean(params[:sender_last_name]),
                                      current_user ? current_user.email : Sanitize.clean(params[:sender_email]),
                                      Sanitize.clean(params[:recipient_name]),
                                      Sanitize.clean(params[:recipient_email]),
                                      Sanitize.clean(params[:note]))
        redirect_to show_posts_url(:year => @post.created_at.year, :month => @post.created_at.month, :day => @post.created_at.day, :slug => @post.slug)
      else
        @sender_first_name = params[:sender_first_name]
        @sender_last_name = params[:sender_last_name]
        @sender_email = params[:sender_email]
        @recipient_name = params[:recipient_name]
        @recipient_email = params[:recipient_email]
        @note = params[:note]
        render 'email'
      end
    end
  end
end
