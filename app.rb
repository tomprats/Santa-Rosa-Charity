require "sinatra/base"

class SantaRosaCharity < Sinatra::Base
  get "/" do
    haml :index
  end
end
