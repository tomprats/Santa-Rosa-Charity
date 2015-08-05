require "sinatra/base"
require "sass"
require "pry" if development?
require "sinatra/reloader" if development?

set :environments, %w{development production staging}

class SantaRosaCharity < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  before do
    @meta_tags = {}
    @meta_tags["og:title"] = @meta_tags["twitter:title"] = "Santa Rosa Charity"
    @meta_tags["og:description"] = @meta_tags["twitter:description"] = "A charity event for Santa Rosa, Guatemala to fund the children’s nutritional program, a new clean water system, and a middle school education."
    @meta_tags["og:site_name"] = "Santa Rosa Charity"
    @meta_tags["og:url"] = request.base_url
    @meta_tags["og:image"] = @meta_tags["twitter:image"] = "#{request.base_url}/img/sticks.jpg"
    @meta_tags["twitter:card"] = "summary"
  end

  def meta_tags
    tags = ""
    @meta_tags.each do |key, value|
      tags += "<meta property=\"#{key}\" content=\"#{value}\"/>"
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
    add_js("jquery.backstretch.min")
    add_js("index")
    add_css("index")

    haml :index
  end
end
