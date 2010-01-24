atom_feed do |feed|
  feed.title("#{DEFAULT_SITE_NAME} - #{DEFAULT_TITLE}")
  feed.updated(@posts.first.created_at)

  @posts.each do |post|
    feed.entry(post, :url => post.permanent_url) do |entry|
      entry.title(post.title)
      entry.content(Maruku.new(post.body).to_html, :type => 'html')
      entry.author do |author|
        author.name("#{post.poster.firstname} #{post.poster.lastname}")
      end
    end
  end
end