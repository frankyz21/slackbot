class SlackCommandsController < ApplicationController
  protect_from_forgery with: :null_session

  def receive
    # CLIENT.chat_postMessage(channel: params[:channel_id], text: "Abc Response", as_user: true)
    case params["text"]
    when "resolve"
      resolve_incident(params)
    when /^declare (.+)/
      open_incident_modal(params)
    end
  end

  def open_incident_modal(params)
    trigger_id = params["trigger_id"]
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
            initial_value: params["text"].sub(/^declare\s+/, '')
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

    CLIENT.views_open(trigger_id: trigger_id, view: modal_view)
  end

  def resolve_incident params
  # Check if the command is executed in a dedicated incident Slack channel
    channel_id = params["channel_id"]
    incident = Incident.find_by(channel_id: channel_id)
    if incident
      incident.update(status: 'resolved', resolved_at: DateTime.now)
      CLIENT.chat_postMessage(channel: channel_id, text: "Congratulatons! Incident '#{incident.title}' resolved.", as_user: true)
    else
      CLIENT.chat_postMessage(channel: channel_id, text: 'This command is only available in dedicated incident channels.', as_user: true)
    end
  end
end
