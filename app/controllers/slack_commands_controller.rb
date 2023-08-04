class SlackCommandsController < ApplicationController
  protect_from_forgery with: :null_session

  def receive
    bot = MySlackBot.instance
    bot.run
    head :ok
  end
end
