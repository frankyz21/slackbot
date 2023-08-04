class SlackCommandsController < ApplicationController
  protect_from_forgery with: :null_session

  def receive    
    case params["text"]
    when /\Aresolve/
      SlackResponder.new(params).resolve_incident
    when /^declare (.+)/
      SlackResponder.new(params).open_incident_modal
    else
      SlackResponder.new(params).command_not_recognized
    end
  end
end
