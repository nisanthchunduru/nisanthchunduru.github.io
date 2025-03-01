require 'sinatra'

get '/' do
  # send_file File.join(settings.root, 'layouts', 'index.html')
  send_file File.join(settings.root, 'public', 'index.html')
end

get '/about' do
  # send_file File.join(settings.root, 'layouts', 'index.html')
  send_file File.join(settings.root, 'public', 'about', 'index.html')
end

get '/bookmarks' do
  # send_file File.join(settings.root, 'layouts', 'index.html')
  send_file File.join(settings.root, 'public', 'bookmarks', 'index.html')
end
