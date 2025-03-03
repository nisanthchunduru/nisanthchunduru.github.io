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

def fetch_page(page_path)
  page_file_path = File.expand_path(File.join('content', "#{page_path}.md"))
  page_file_text = File.read(page_file_path)
  page_file_header_yaml = page_file_text.match(/^---\n*[\s\S]*?\n---\n/)[0]
  page_file_header_hash = YAML.safe_load(page_file_header_yaml).to_h
  page_markdown = page_file_text.gsub(/^---\n*[\s\S]*?\n---\n/, '')
  page_html = markdown_to_html(page_markdown)
  page_date = Time.parse(page_file_header_hash['date'])
  page = page_file_header_hash.merge({
    "html" => page_html,
    "path" => page_path
  })
  if page_file_header_hash['date']
    page_date = Time.parse(page_file_header_hash['date'])
    page['date'] = page_date.strftime('%b %d, %Y')
  end
  return page
end

def fetch_subpages(path)
  subpage_file_paths = Dir.glob(File.join('content', path, '*.md'))
  subpages = []
  subpage_file_paths.each do |subpage_file_path|
    subpage_file_slug = File.basename(subpage_file_path, '.md')
    subpage = fetch_page(File.join(path, subpage_file_slug))
    subpages << subpage
  end
  return subpages
end

configure do
  set :public_folder, File.expand_path('static', File.dirname(__FILE__))
  Liquid::Template.file_system = Liquid::LocalFileSystem.new(File.join(settings.root, "templates"))
  # set :views, File.join(File.dirname(__FILE__), '/templates')
  set :views, "templates"
  set :host_authorization, { permitted_hosts: [] }
end

get '/' do
  posts = fetch_subpages('/posts')
  liquid :index, locals: { posts: posts }
end

get '/posts/:post_slug' do
  post_slug = params[:post_slug]
  post = fetch_page("/posts/#{post_slug}")
  liquid :post, locals: post
end

get '/bookmarks' do
  page = fetch_page('/bookmarks')
  liquid :bookmarks, locals: page
end

get '/about' do
  page = fetch_page('/about')
  liquid :about, locals: page
end
