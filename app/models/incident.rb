class Incident < ApplicationRecord
  enum severity: {
    sev0: 0,
    sev1: 1,
    sev2: 2
  }

  enum status: {
    open: 0,
    resolved: 1
  }

  def self.create_incident(title, description, severity)
    incident = Incident.create(title: title, description: description, severity: severity)
    channel = create_slack_channel(incident)
    incident.update(channel_id: channel.id)
    incident
  end

  def self.create_slack_channel(incident)
    # You'll need the bot token to interact with the Slack API
    bot_token = ENV['SLACK_BOT_TOKEN']

    # Slack client setup
    client = Slack::Web::Client.new(token: bot_token)

    # Define the name of the channel based on the incident title
    # You can customize this as needed
    channel_name = "incident-#{incident.title.downcase.gsub(/\s+/, '-')}"
    
    # Create the Slack channel
    begin
      response = client.conversations_create(name: channel_name)
      channel = response['channel']
    rescue Slack::Web::Api::Errors::SlackError => e
      # Handle any errors that occur during channel creation
      puts "Error creating Slack channel: #{e.message}"
      return nil
    end

    # Invite relevant users to the channel, if needed
    # You can invite specific users or the incident's creator to the channel as necessary
    # For example:
    # client.conversations_invite(channel: channel['id'], users: ['U12345'])

    # Return the created channel object
    channel
  end
  
end
