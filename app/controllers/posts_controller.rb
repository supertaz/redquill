class PostsController < ApplicationController
  caches_page   :index, :show, :tag
  cache_sweeper :post_sweeper, :only => [:create, :update, :delete]

  before_filter :require_user, :only => [:new, :edit, :create, :update]

  def index
    respond_to do |format|
      format.html {redirect_to show_posts_url(:year => 'all')}
      format.atom {
        @posts = Post.recent
        render :atom => @posts
      }
    end
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
      if params[:commit] == "Publish"
        @post.draft = false
      else
        @post.draft = true
      end
      if @post.save
        if @post.draft?
          redirect_to show_draft_url(@post)
        else
          @post.publish!
          redirect_to show_posts_url(:year => @post.published_at.year, :month => @post.published_at.month, :day => @post.published_at.day, :slug => @post.slug)
        end
      else
        render '_form'
      end
    else
      redirect_to show_posts_url(:year => @post.published_at.year, :month => @post.published_at.month, :day => @post.published_at.day, :slug => @post.slug)
    end
  end

  def edit
    @post = Post.find(params[:id])
    if current_user && (@post.poster.id == current_user.id || current_user.is_admin?)
        render '_form'
    else
      unless @post.draft?
        redirect_to show_posts_url(:year => @post.published_at.year, :month => @post.published_at.month, :day => @post.published_at.day, :slug => @post.slug)
      else
        redirect_to show_posts_url(:year => 'all')
      end
    end
  end

  def update
    @post = Post.find(params[:id])
    if current_user
      if @post.draft?
        was_draft = true
      else
        was_draft = false
      end
      if params[:commit] == 'Save as draft'
        @post.draft = true
      else
        @post.draft = false
      end
      if (@post.poster.id == current_user.id || current_user.is_admin?) && @post.update_attributes(params[:post])
        unless @post.draft?
          if was_draft
            @post.publish!
          end
          redirect_to show_posts_url(:year => @post.published_at.year, :month => @post.published_at.month, :day => @post.published_at.day, :slug => @post.slug)
        else
          redirect_to show_draft_url(@post)
        end
      elsif @post.poster.id == current_user.id || current_user.is_admin?
        render '_form'
      else
        unless @post.draft?
          redirect_to show_posts_url(:year => @post.published_at.year, :month => @post.published_at.month, :day => @post.published_at.day, :slug => @post.slug)
        else
          redirect_to show_posts_url(:year => 'all')
        end
      end
    else
      unless @post.draft?
        redirect_to show_posts_url(:year => @post.published_at.year, :month => @post.published_at.month, :day => @post.published_at.day, :slug => @post.slug)
      else
        redirect_to show_posts_url(:year => 'all')
      end
    end
  end

  def show
    if params[:year] == 'all'
      @posts = Post.by_age.paginate(:page => params[:page], :per_page => 5)
      render_post_list
    else
      unless params[:slug].nil? || params[:day].nil?|| params[:month].nil? || params[:year].nil?
        posts = Post.by_slug_and_date(params[:slug], params[:year], params[:month], params[:day]).paginate(:page => params[:page], :per_page => 5)
        if posts.length > 1
          @posts = posts
          render_post_list
        else
          @post = posts[0]
        end
      else
        if params[:slug].nil? && !params[:day].nil? && !params[:month].nil? && !params[:year].nil?
          posts = Post.by_date(params[:year], params[:month], params[:day]).paginate(:page => params[:page], :per_page => 5)
          if posts.length > 1
            @posts = posts
            render_post_list
          else
            @post = posts[0]
          end
        elsif params[:slug].nil? && params[:day].nil? && !params[:month].nil? && !params[:year].nil?
          posts = Post.by_month(params[:year], params[:month]).paginate(:page => params[:page], :per_page => 5)
          if posts.length > 1
            @posts = posts
            render_post_list
          else
            @post = posts[0]
          end
        elsif params[:slug].nil? && params[:day].nil? && params[:month].nil? && !params[:year].nil?
          posts = Post.by_year(params[:year]).paginate(:page => params[:page], :per_page => 5)
          if posts.length > 1
            @posts = posts
            render_post_list
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
        redirect_to show_posts_url(:year => @post.published_at.year, :month => @post.published_at.month, :day => @post.published_at.day, :slug => @post.slug)
      end
      redirect_to show_posts_url(:year => 'all')
    else
      redirect_to show_posts_url(:year => @post.published_at.year, :month => @post.published_at.month, :day => @post.published_at.day, :slug => @post.slug)
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
        redirect_to show_posts_url(:year => @post.published_at.year, :month => @post.published_at.month, :day => @post.published_at.day, :slug => @post.slug)
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

  def list_drafts
    if current_user && (current_user.is_poster? || current_user.is_admin?)
      @posts = Post.drafts(current_user).paginate(:page => params[:page], :per_page => 5)
      render 'list'
    else
      redirect_to show_posts_url(:year => 'all')
    end
  end

  def show_draft
    if current_user && (current_user.is_poster? || current_user.is_admin?)
      @post = Post.drafts(current_user).find(params[:id])
      render 'show'
    else
      redirect_to show_posts_url(:year => 'all')
    end
  end

  private

#
# Determine which post is freshest in @posts and use that to set etag and last_modified headers
#
  def render_post_list
    freshest_post = Post.new
    @posts.each do |post|
      unless freshest_post.published_at.nil?
        if post.updated_at > freshest_post.updated_at
          freshest_post = post
        end
      else
        freshest_post = post
      end
    end
    if stale?(
            :etag => freshest_post,
            :last_modified => freshest_post.updated_at
            )
      render 'list'
    end
  end
end
