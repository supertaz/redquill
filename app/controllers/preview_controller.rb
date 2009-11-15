class PreviewController < ApplicationController
  def parse_markdown
    render :text => Maruku.new(params[:data]).to_html
  end

end
