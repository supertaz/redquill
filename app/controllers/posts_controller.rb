class PostsController < ApplicationController
  def new
    @post = Post.new()
    render '_form'
  end

  def create
    @post = Post.new(params[:post])
    @post.poster = current_user
    if @post.save
      redirect_to root_url
    else
      render '_form'
    end
  end

  def edit
    @post = Post.find(params[:id])
    render '_form'
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def show
    unless params[:slug].nil? || params[:day].nil?|| params[:month].nil? || params[:year].nil?
      @posts = Post.by_slug_and_date(params[:slug], params[:year], params[:month], params[:day])
    else
      if params[:slug].nil? && !params[:day].nil? && !params[:month].nil? && !params[:year].nil?
        @posts = Post.by_date(params[:year], params[:month], params[:day])
      elsif params[:slug].nil? && params[:day].nil? && !params[:month].nil? && !params[:year].nil?
        @posts = Post.by_month(params[:year], params[:month])
      elsif params[:slug].nil? && params[:day].nil? && params[:month].nil? && !params[:year].nil?
        @posts = Post.by_year(params[:year])
      else
        redirect_to root_url
      end
    end
  end

  def delete
    @post = Post.find(params[:id])
    if @post.poster == current_user
      @post.destroy
    end
    redirect_to root_url
  end

  def list
    
  end

  def tag
    @tag = params[:tag_name]
    @posts = Post.tagged_with(@tag).by_age.paginate(:page => params[:page], :per_page => 5)
  end
end
