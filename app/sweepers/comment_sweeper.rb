class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment

  def after_save(comment)
    post = comment.post
    self.class::sweep(post.local_date.gsub(/-.*-.*$/, '').to_i, post.local_date.gsub(/.*-(.*)-.*$/, '\1').to_i, post.local_date.gsub(/.*-.*-(.*)$/, '\1').to_i)
  end

  def self.sweep(year,month,day)
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == RAILS_ROOT+"/public"
      FileUtils.rm_r(Dir.glob(cache_dir+"/posts/#{year}/#{month}/#{day}")) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Cache directory '#{cache_dir}/posts/#{year}/#{month}/#{day}' fully swept.")
    end
  end
end