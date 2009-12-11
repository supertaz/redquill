class AjaxController < ApplicationController
  layout false
  cache_sweeper :comment_sweeper, :only => [:opinion]

  def parse_markdown
    render :text => Maruku.new(params[:data]).to_html
  end

  def opinion
    json_response = Hash.new()
    json_response[:logged_in] = current_user ? true : false
    if current_user then
      @comment = Comment.find(params[:cid])
      case params[:o]
        when 'a'
          @comment.agree(current_user)
        when 'd'
          @comment.disagree(current_user)
      end
      @comment.save
      json_response[:opinion_div_id] = "#opinions-#{@comment.id}"
      json_response[:opinion_data] = render_to_string 'common/_comment_opinions_wrapper'
    end
    render :json => json_response
  end

  def links
    json_response = Hash.new()
    json_response[:usernav] = render_to_string 'common/_usernav'
    if current_user
      json_response[:sitenav] = render_to_string 'common/_sitenav_conditional'
    else
      json_response[:sitenav] = nil
    end
    posts = Array.new()
    post_ids = Array.new()
    if params[:pc].to_i > 0 then
      params[:pc].to_i.times do |i|
        pid = "pid#{i}"
        if i == 0
          post_ids = "#{params[pid.to_sym]}"
        else
          post_ids += ",#{params[pid.to_sym]}"
        end
      end
      post_list = Post.in_list(post_ids)
      post_list.each do |post|
        post_hash = Hash.new()
        post_hash[:is_poster] = current_user ? post.poster.id == current_user.id : false
        post_hash[:post_div_id] = "#post-#{post.id}"
        @post = post
        post_hash[:comment_info] = render_to_string 'common/_post_comment_info'
        posts << post_hash
      end
    end
    json_response[:posts] = posts
    render :json => json_response
  end
end
