Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

CLIENT = Slack::Web::Client.new