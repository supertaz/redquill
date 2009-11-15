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
    @posts = Post.by_slug_and_date(params[:slug], params[:year], params[:month], params[:day])
  end

  def delete
    
  end

  def list
    
  end
end
