require 'trello'
require 'time'

BOARD_ID='your_board_id'
LIST_NAME='Done'

print "type your consumer key: "
consumer_key=STDIN.noecho(&:gets).chomp

print "\ntype your consumer secret: "
consumer_secret=STDIN.noecho(&:gets).chomp

print "\ntype your oauth token: "
oauth_token=STDIN.noecho(&:gets).chomp

Trello.configure do |config|
  config.consumer_key = consumer_key
  config.consumer_secret = consumer_secret
  config.oauth_token = oauth_token
end

# ボードを取得
board = Trello::Board.find(BOARD_ID)

# リストのIDを取得
list_id = nil
board.lists.each do |l|
  list_id = l.id if l.name == LIST_NAME
end

exit if list_id.nil?

# リストから5日以上動きのないカードをアーカイブ
list = Trello::List.find(list_id)
list.cards.each do |c|
  if c.last_activity_date.to_date > Time.now.to_date + 5
    c.close!
    print "\narchive card: " + c.name
  end
end

