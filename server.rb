require 'pry'

require 'sinatra'
require 'liquid'
require 'redcarpet'
# require 'kramdown'

def markdown_to_html(markdown)
  preprocessed_markdown = markdown.gsub(/(?<!^\n)^```/, "\n```")
  Redcarpet::Markdown.new(
    Redcarpet::Render::Safe.new,
    autolink: true,
    tables: true,
    fenced_code_blocks: true,
    highlight: true
  ).render(preprocessed_markdown)
end

def fetch_post(post_slug)
  post_file_name = post_slug + ".md"
  post_file_path = File.expand_path(File.join('content', 'posts', post_file_name))
  post_file_text = File.read(post_file_path)
  post_file_header_yaml = post_file_text.match(/^---\n*[\s\S]*?\n---\n/)[0]
  post_file_header_hash = YAML.safe_load(post_file_header_yaml).to_h
  post_markdown = post_file_text.gsub(/^---\n*[\s\S]*?\n---\n/, '')
  post_html = markdown_to_html(post_markdown)
  post_date = Time.parse(post_file_header_hash['date'])
  post = post_file_header_hash.merge({
    "date" => post_date.strftime('%b %d, %Y'),
    "html" => post_html,
    "relPermalink" => "/posts/#{post_slug}"
  })
  return post
end

def fetch_all_posts
  post_files = Dir.glob('content/posts/*.md')
  posts = []
  post_files.each do |post_file|
    post_slug = File.basename(post_file, '.md')
    post = fetch_post(post_slug)
    posts << post
  end
  return posts
end

configure do
  Liquid::Template.file_system = Liquid::LocalFileSystem.new(File.join(settings.root, "templates"))
  # set :views, File.join(File.dirname(__FILE__), '/templates')
  set :views, "templates"
end

get '/' do
  posts = fetch_all_posts
  liquid :index, locals: { posts: posts }
end

get '/posts/:post_slug' do
  post = fetch_post(params[:post_slug])
  liquid :post, locals: post
end

get '/bookmarks' do
  liquid :bookmarks
end

get '/about' do
  liquid :about
end
