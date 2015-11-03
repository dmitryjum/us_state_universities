class API::V1::SchoolsController < ApplicationController
  def index
    @schools = School.where_params_are params
    respond_to do |format|
      format.json {render json: @schools, status: 200}
      format.xml {render xml: @schools, status: 200}
    end
  end

  def top_twenty_keys
    @keys = School.top_twenty_keys
    respond_to do |format|
      format.json {render json: @keys, status: 200}
      format.xml {render xml: @keys, status: 200}
    end
  end
end