class Api::V1::ComparisonsController < Api::V1::ApplicationController
  
  skip_load_and_authorize_resource
      
  caches_action :search, expires_in: 3600.seconds, if: Proc.new { params[:afterTimestamp].blank? }, layout: false
  
  def search
    # returns the last 20 comparisons
    @events = Event.where(name: "comparison").desc(:created_at).limit(20)
    unless params[:afterTimestamp].blank?
      @events = @events.where :created_at.gt => Time.at(params[:afterTimestamp].to_i)
    end
  end
  
end