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

  # swagger

  swagger_controller :schools, "Schools"

  swagger_api :index do
    summary "Fetches all School objects"
    notes "This lists all USA State college objects in JSON"
    param :query, :title, :string, :optional, "Find School by title"
    param :query, :details, :string, :optional, "Find all schools with specific 'details' key"
    param :query, :details, :hash, :optional, "Find all schools with specific key and arbitrary value as {details: {'type' => 'pub'}}"
    response :ok, "Success", :User
    response :not_acceptable
    response :not_found
  end

  swagger_api :top_twenty_keys do
    summary "Fetches list of top twenty 'details' keys with count of their apperance in DataBase"
    notes "The response of this method serves as guide for user on what to query"
    response :ok, "Success", :User
    response :not_found
  end
end