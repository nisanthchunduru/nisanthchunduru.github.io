notion_secret = ENV['NOTION_SECRET']
unless notion_secret
  throw "Please create a Notion integration, generate a secret and provide it in the 'NOTION_SECRET' environment variable"
end

require 'httparty'
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
end

notion = NotionApi.new(notion_secret)
posts_page_id = 'c0b6dad7496849ef81fc655bc4213c02'
# url = "https://api.notion.com/v1/blocks/#{posts_page_id}/children?page_size=100"
# response = HTTParty.get(url, headers: {
#   "Notion-Version" => '2022-02-22',
#   "Authorization" => "Bearer #{notion_secret}"
# })
response = notion.get("/blocks/#{posts_page_id}/children?page_size=100")
blocks = response['results']
blocks.each do |block|
  post_id = block['id']
  post_created_at = Time.parse(block['last_edited_time'])
  post_path = File.expand_path("../content/posts/#{post_id}.md", File.dirname(__FILE__))

  next if File.exist?(post_path) && File.mtime(post_path) >= post_created_at

  post_markdown = NotionToMd.convert(page_id: post_id, token: notion_secret)

  post_title = block['child_page']['title']
  post_created_at = Time.parse(block['created_time'])
  post_front_matter = {
    'title' => post_title,
    'date' => post_created_at.iso8601
  }
  post_front_matter_yaml = post_front_matter.to_yaml.chomp
  post = <<-POST
#{post_front_matter_yaml}
---

#{post_markdown}
POST
  File.write(post_path, post)
end
