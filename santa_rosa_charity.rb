require "sinatra/base"
require "sass"
require "pry" if development?
require "sinatra/reloader" if development?

set :environments, %w{development production staging}

class SantaRosaCharity < Sinatra::Base
  before do
    @meta_tags = {}
    @meta_tags[:title] = "Santa Rosa Charity BBQ"
    @meta_tags[:site_name] = "Santa Rosa Charity BBQ"
    @meta_tags[:url] = request.base_url
    # @meta_tags[:image] = "https://cdn.traitify.com/my/images/logos/square.png"
  end

  def meta_tags
    tags = ""
    @meta_tags.each do |key, value|
      tags += "<meta property=\"og:#{key}\" content=\"#{value}\"/>"
    end
    tags
  end

  def add_css(css)
    @css ||= []
    @css << css
  end

  def stylesheets
    @css ||= []
    @css << ["main"]
    @css.flatten.uniq.map do |css|
      "<link href=\"/css/#{css}.css\" rel=\"stylesheet\">"
    end.join
  end

  def add_js(js)
    @js ||= []
    @js << js
  end

  def javascript
    @js ||= []
    @js << ["main"]
    @js.flatten.uniq.map do |script|
      "<script type=\"text/javascript\" src=\"/js/#{script}.js\"></script>"
    end.join
  end

  def action
    return @action if @action
    @action = request.path.gsub("/", "-")
    @action = "index" if @action.length == 1
  end

  get "/css/:name.css" do
    content_type "text/css", charset: "utf-8"
    scss :"../public/scss/#{params[:name]}"
  end

  get "/" do
    haml :index
  end
end
