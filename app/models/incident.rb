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

  def self.create_slack_incident(params)
    payload = JSON.parse(params["payload"])
    title = payload.dig("view", "state","values","title_input","title_input","value")
    description = payload.dig("view", "state","values","description_input","description_input", "value")
    severity = payload.dig("view", "state","values", "severity_input","severity_input","selected_option","value")
    creator = payload.dig("user", "name")

    incident = Incident.create!(title: title, description: description, severity: severity, creator: creator, status: "open")
    channel = create_slack_channel(incident)
    incident.update(channel_id: channel.id)
    incident
  end

  def self.create_slack_channel(incident)
    channel_name = "incident-#{incident.title.downcase.gsub(/\s+/, '-')}"
    channel = nil
    begin
      response = CLIENT.conversations_create(name: channel_name)
      channel = response['channel']
    rescue Slack::Web::Api::Errors::SlackError => e
      puts "Error creating Slack channel: #{e.message}"
      return nil
    end
    channel
  end
  
end
