class HomeController < ApplicationController
  def index
    @posts = Post.by_age.paginate(:page => params[:page], :per_page => 5)
  end
end
