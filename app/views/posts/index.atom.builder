atom_feed do |feed|
  feed.title('DevKoans - A blog of things I know might be true')
  feed.updated(@posts.first.created_at)

  @posts.each do |post|
    feed.entry(post, :url => post.permanent_url) do |entry|
      entry.title(post.title)
      entry.content(Maruku.new(post.body).to_html, :type => 'html')
      entry.author do |author|
        author.name('Jon Mischo')
      end
    end
  end
end