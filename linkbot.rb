require 'bundler/setup'
require 'sinatra'
require 'redis'

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

__END__

@@links
<html>
<head>
  <style type="text/css">
    ul > li { width: 400px; list-style: none; margin: 20px 0; padding: 13px 20px; background-color: #ffffff; border-bottom: 1px solid #cccccc; }
  </style>
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
  <script type="text/javascript">
    $(function() {
      $('input[name=link]').focus().submit(function(event) { if(event.keyCode === 13){ $('form').submit(); } });
      setInterval(function() { $('ul.links').load('/ ul.links li'); }, 1000);
    });
  </script>
</head>
<body style="background-color: #eeeeee; color: #333333; font: 24px Arial; margin: 40px auto; width: 400px;">
  <ul class="links">
    <% @links.each do |link| %>
      <li><a href="<%= link %>"><%= link %></a></li>
    <% end %>
  </ul>
  <ul>
    <li>
      <form method="post" action="/" style="margin: 0; padding: 0;">
        <input type="text" name="link" style="width: 360px; height: 30px; font: 24px Arial; border: none; outline: none;" />
      </form>
    </li>
  </ul>
</body>
</html>