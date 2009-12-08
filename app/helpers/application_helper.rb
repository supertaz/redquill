# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def tags_for_cloud
    Post.tag_counts_on(:tags)
  end

  def counts_for_archive
    Post.counts_by_month
  end
end
