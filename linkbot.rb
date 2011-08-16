configure do
  set :logging, false
  enable :inline_templates
  REDIS = Redis.new
end

helpers do
  def add_link(link)
    REDIS.rpush 'links', link
  end
  
  def get_links
    REDIS.lrange 'links', 0, -1
  end
end

get '/' do
  @links = get_links
  erb :links
end

post '/' do
  add_link(params[:link])
  redirect '/'
end