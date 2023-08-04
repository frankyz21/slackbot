class IncidentsController < ApplicationController
  def index
    @incidents = Incident.all.order(title: sort_direction)
  end
    
  def show
    @incident = Incident.find(params[:id])
  end
  
  private
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
