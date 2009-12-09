class PostSweeper < ActionController::Caching::Sweeper
  observe Post, User

  def after_post_create(post)
    self.class::sweep
  end

  def after_post_update(post)
    self.class::sweep
  end

  def after_user_update(user)
    self.class::sweep
    expire_page(:controller => 'users', :action => 'show', :id => user.username)
  end

  def after_destroy(post)
    self.class::sweep
  end

  def self.sweep
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == RAILS_ROOT+"/public"
      FileUtils.rm_r(Dir.glob(cache_dir+"/posts")) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Cache directory '#{cache_dir}/posts' fully swept.")
      FileUtils.rm_r(Dir.glob(cache_dir + '/posts.atom')) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Feed '#{cache_dir}/posts.atom' swept.")
    end
  end
end