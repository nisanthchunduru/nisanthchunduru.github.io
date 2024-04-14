env_file_path = File.expand_path('../.env', File.dirname(__FILE__))
if File.exist?(env_file_path)
  require 'dotenv'
  Dotenv.load(env_file_path)
end
notion_token = ENV['NOTION_TOKEN']
unless notion_token
  throw "Please create a Notion integration, generate a secret and provide it in the 'NOTION_TOKEN' environment variable"
end

NOTION_TOKEN = ENV['NOTION_TOKEN']
POSTS_DATABASE_ID = '292e1d2fd4ca474aa0e6396cce36a2c5'

require 'httparty'
require 'notion-ruby-client'
require 'notion_to_md'
require 'yaml'
require 'pry'

class NotionApi
  BASE_URL = "https://api.notion.com/v1"

  def initialize(api_secret)
    @api_secret = api_secret
  end

  def get(path)
    url = File.join(BASE_URL, path)
    HTTParty.get(url, headers: {
      "Notion-Version" => '2022-02-22',
      "Authorization" => "Bearer #{@api_secret}"
    })
  end

  def post(path)
    url = File.join(BASE_URL, path)
    HTTParty.post(url, headers: {
      "Notion-Version" => '2022-02-22',
      "Authorization" => "Bearer #{@api_secret}"
    })
  end
end

def sync_posts_from_notion
  notion = NotionApi.new(NOTION_TOKEN)
  response = notion.post("/databases/#{POSTS_DATABASE_ID}/query")
  blocks = response['results']
  blocks.each do |block|
    post_id = block['id']
    post_last_edited_at = Time.parse(block['last_edited_time'])
    post_path = File.expand_path("../content/posts/#{post_id}.md", File.dirname(__FILE__))
    next if File.exist?(post_path) && File.mtime(post_path) >= post_last_edited_at

    post_date = Time.parse(block['created_time'])
    if (block['properties'] && block['properties']['date'])
      post_date = Time.parse(block['properties']['date']['date']['start'])
    end
    post_markdown = NotionToMd.convert(page_id: post_id, token: NOTION_TOKEN)
    post_title = block['properties']['Name']['title'][0]['plain_text']
    post_front_matter = {
      'title' => post_title,
      'date' => post_date.iso8601
    }
    post_front_matter_yaml = post_front_matter.to_yaml.chomp
    post = <<-POST
#{post_front_matter_yaml}
---

#{post_markdown}
POST
    File.write(post_path, post)
  end
end

def do_exit
  puts 'Exiting...'
  exit
end
Signal.trap("TERM") { do_exit }
Signal.trap("INT") { do_exit }

loop do
  puts "Syncing posts from Notion..."
  sync_posts_from_notion
  puts "Done."
  sleep 7.5
end
