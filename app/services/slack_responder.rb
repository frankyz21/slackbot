class SlackResponder
  def initialize(params)    
    @channel_id = params["channel_id"]
    @client = CLIENT
    @trigger_id = params["trigger_id"]
  end

  def open_incident_modal
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
            initial_value: @params["text"].sub(/^declare\s+/, '')
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

    @client.views_open(trigger_id: @trigger_id, view: modal_view)
  end

  def resolve_incident
    incident = Incident.find_by(channel_id: @channel_id)
    if incident
      incident.update(status: 'resolved', resolved_at: DateTime.now)
      @client.chat_postMessage(channel: @channel_id, text: "Congratulatons! Incident '#{incident.title}' resolved.", as_user: true)
    else
      @client.chat_postMessage(channel: @channel_id, text: 'This command is only available in dedicated incident channels.', as_user: true)
    end
  end

  def command_not_recognized
    @client.chat_postMessage(channel: @channel_id, text: "Sorry, your command is not recognized.", as_user: true)
  end
end