class IncidentsController < ApplicationController
  protect_from_forgery with: :null_session
  def index
    @incidents = Incident.all.order(title: sort_direction)
  end

  def create
    Incident.create_slack_incident(params)
  end
    
  def show
    @incident = Incident.find(params[:id])
  end
  
  private
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
