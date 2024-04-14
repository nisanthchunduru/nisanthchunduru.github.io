require_relative '../lib/blog/notion-synchronizer'

BLOG_CONTENT_NOTION_PAGE_ID = '0f1b55769779411a95df1ee9b4b070c9'
BLOG_CONTENT_DIR = File.expand_path('../../content', __FILE__)

def do_exit
  puts 'Exiting...'
  exit
end
Signal.trap("TERM") { do_exit }
Signal.trap("INT") { do_exit }

loop do
  puts "Syncing posts from Notion..."
  NotionSynchronizer.run(
    page_id: BLOG_CONTENT_NOTION_PAGE_ID,
    destination_dir: BLOG_CONTENT_DIR
  )
  puts "Done."
  sleep 10
end
