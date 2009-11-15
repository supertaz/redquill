class HomeController < ApplicationController
  def index
    @posts = Post.last_five
  end
end
