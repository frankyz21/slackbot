class SlackCommandsController < ApplicationController
  protect_from_forgery with: :null_session

  def receive    
    SlackResponder.new(params).process
  end
end
