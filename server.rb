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
    "path" => page_path,
    "date" => page_file_header_hash['date']
  })
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
  set :bind, '0.0.0.0'
  set :host_authorization, { permitted_hosts: [] }
  set :public_folder, File.expand_path('static', File.dirname(__FILE__))
  Liquid::Template.file_system = Liquid::LocalFileSystem.new(File.join(settings.root, "templates"))
  # set :views, File.join(File.dirname(__FILE__), '/templates')
  set :views, "templates"
end

module LiquidFilters
  def asset_url(file)
    asset_hash = cached_asset_hash(file) || "nohash"
    "/#{file}?v=#{asset_hash}"
  end

  def sort_by(entities, key, direction='desc')
    sorted_entities = entities.sort_by { |e| e[key] }
    direction == 'desc' ? sorted_entities.reverse : sorted_entities
  end

  def format_time(time, format = '%b %d, %Y')
    return '' if time.nil?
    Time.parse(time).strftime(format)
  end

  private

  def cached_asset_hash(file)
    @asset_hashes ||= {}
    return @asset_hashes[file] if @asset_hashes.key?(file)

    # public_folder = settings.public_folder
    public_folder = File.expand_path('static', File.dirname(__FILE__))
    asset_path = File.join(public_folder, file)
    if File.exist?(asset_path)
      @asset_hashes[file] = Digest::MD5.file(asset_path).hexdigest[0, 10]
    else
      @asset_hashes[file] = nil
    end
  end
end

Liquid::Template.register_filter(LiquidFilters)

get '/' do
  posts = fetch_subpages('/posts')
  # posts = fetch_subpages('/posts').sort_by { |post| post['date'] }.reverse
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
