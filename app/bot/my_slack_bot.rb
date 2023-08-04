class MySlackBot < SlackRubyBot::Bot

  match(/^(?<bot>\S*)[\s]*(declare)\s(?<title>.+)$/i) do |client, data, match|
    # title = match['title']
    # client.chat_postMessage(channel: data.channel, text: "Creating a new incident: '#{title}'")

    # # Open the modal for incident creation
    # open_incident_modal(client, data.user)
  end

  command 'resolve' do |client, data, _match|
    # Check if the command is executed in a dedicated incident Slack channel
    # channel_id = data.channel
    # incident = Incident.find_by(channel_id: channel_id)
    # if incident
    #   incident.update(status: 'Resolved')
    #   # Calculate the time taken to resolve the incident and display it in the channel
    #   # You can use the `created_at` and `updated_at` fields of the incident to calculate the time
    #   time_to_resolve = incident.updated_at - incident.created_at
    #   client.say(channel: data.channel, text: "Incident '#{incident.title}' resolved. Time to resolution: #{time_to_resolve} seconds.")
    # else
    #   client.say(channel: data.channel, text: 'This command is only available in dedicated incident channels.')
    # end
  end

  def open_incident_modal(client, user)
    trigger_id = user.trigger_id
    modal_view = {
      type: 'modal',
      callback_id: 'create_incident_modal',
      title: {
        type: 'plain_text',
        text: 'Create New Incident'
      },
      submit: {
        type: 'plain_text',
        text: 'Create'
      },
      close: {
        type: 'plain_text',
        text: 'Cancel'
      },
      blocks: [
        {
          type: 'input',
          block_id: 'title_input',
          element: {
            type: 'plain_text_input',
            action_id: 'title_input',
            initial_value: params["text"]
          },
          label: {
            type: 'plain_text',
            text: 'Title'
          }
        },
        {
          type: 'input',
          block_id: 'description_input',
          element: {
            type: 'plain_text_input',
            action_id: 'description_input'
          },
          label: {
            type: 'plain_text',
            text: 'Description'
          }
        },
        {
          type: 'input',
          block_id: 'severity_input',
          element: {
            type: 'static_select',
            action_id: 'severity_input',
            options: [
              { text: { type: 'plain_text', text: 'Sev0' }, value: 'Sev0' },
              { text: { type: 'plain_text', text: 'Sev1' }, value: 'Sev1' },
              { text: { type: 'plain_text', text: 'Sev2' }, value: 'Sev2' }
            ]
          },
          label: {
            type: 'plain_text',
            text: 'Severity'
          }
        }
      ]
    }

    client.views_open(trigger_id: trigger_id, view: modal_view)
  end
end
