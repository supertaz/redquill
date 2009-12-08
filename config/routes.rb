ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'posts'

  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.bio 'bio', :controller => 'bio', :action => 'index'

  map.paged_tags 'tags/:tag_name/page/:page', :controller => 'posts', :action => 'tag'
  map.tag_search 'tags/:tag_name', :controller => 'posts', :action => 'tag'

  map.all_paged '/posts/all/page/:page', :controller => 'posts', :action => 'show', :year => 'all'
  map.resources :posts, :collection => {:delete => :get}, :except => :show, :has_many => :comments do |post|
    post.email '/share/email', :controller => 'posts', :action => 'email'
    post.resources :comments,  :collection => {:new => :get, :create => :post},
                                :except => [:list, :show, :edit, :destroy, :update] do |comment|
      comment.reply '/reply', :controller => 'comments', :action => 'reply'
      comment.agree '/opinion', :controller => 'comments', :action => 'agree'
      comment.disagree '/disagree', :controller => 'comments', :action => 'disagree'
    end
  end
  map.connect '/posts/:year/:month/:day/page/:page', :controller => 'posts', :action => 'show'
  map.connect '/posts/:year/:month/page/:page', :controller => 'posts', :action => 'show'
  map.connect '/posts/:year/page/:page', :controller => 'posts', :action => 'show'
  map.show_posts '/posts/:year/:month/:day/:slug', :controller => 'posts', :action => 'show', :slug => nil, :day => nil, :month => nil, :year => nil

  map.resources :users, :except => [:list, :destroy] do |user|
    user.email '/email', :controller => 'users', :action => 'email'
  end

  map.resources :user_sessions

  map.handle_json_links '/json/links', :controller => 'ajax', :action => 'links', :method => :get
  map.handle_opinion '/json/opinion', :controller => 'ajax', :action => 'opinion', :method => :get
  map.parse_markdown '/preview/parse_markdown', :controller => 'ajax', :action => 'parse_markdown', :method => :post
end
