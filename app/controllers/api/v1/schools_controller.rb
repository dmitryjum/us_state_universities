class Api::V1::SchoolsController < ApplicationController
  before_action :set_school, only: :update

  api :GET, "/v1/schools", "List all schools"
  param :title, String, :desc => "Find school by arbitrary title \n {'title' => 'Conn'}, or '/api/v1/schools?title=conn'"
  param :details, ["String", "Hash"], :desc => "Find all schools that contain your specific key in their 'details' attribute \n {'details' => 'website'}, or '/api/v1/schools?details=website'"
  param :details_key, Hash,
   :desc => "Find all schools by specific key and arbitrary value in its 'details' attribute. \n eg: {'details' => {'location' => 'el paso'}}, or '/api/v1/schools?details%5Blocation%5D=el+paso'"
  example "{\"id\":174,\n \"title\":\"Connecticut State Universities\",\n \"details\":\n  {\"type\":\"Public university system\",\n  \"motto\":\"Qui Transtulit Sustinet\",\n  \"website\":\"http://www.ct.edu\",\n  \"location\":\"Hartford, Connecticut, United States, Coordinates: 41°46′12″N 72°42′03″W﻿ / ﻿41.77007°N 72.70088°W﻿ / 41.77007; -72.70088\",\n  \"students\":\"34,824 (2012)\",\n  \"postgraduates\":\"5,516 (2012)\",\n  \"undergraduates\":\"29,308 (2012)\"},\n \"created_at\":\"2015-10-22T01:15:57.264-04:00\",\n \"updated_at\":\"2015-10-26T00:39:07.133-04:00\"}"
  def index
    @schools = School.where_params_are params
    respond_to do |format|
      format.json {render json: @schools, status: 200}
      format.xml {render xml: @schools, status: 200}
    end
  end

  api :GET, "/v1/schools/top_twenty_keys", "List 20 popular k/v pairs, where keys are 'details' json keys and values are count of their appereances in DB"
  def top_twenty_keys
    @keys = School.top_twenty_keys
    respond_to do |format|
      format.json {render json: @keys, status: 200}
      format.xml {render xml: @keys, status: 200}
    end
  end

  def update
    authenticate_request!
    if @school.update(school_params)
      render status: 201, json: @school
    else
      render json: @school.errors, status: :unprocessable_entity
    end
  end

  private

  def set_school
    @school = School.find_by_title(params[:title])
  end

  def school_params
    params.require(:school).permit(:title, :details => {})
  end
end