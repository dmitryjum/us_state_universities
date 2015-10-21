module API
  class SchoolsController < ApplicationController

    def index
      if params[:title].present?
        @schools = School.where("title ~* ?", params[:title])
      elsif params[:details].present?
        # @schools = School.where(jsonb finder)
      else
        @schools = School.all
      end
      render json: @schools, status: 200
    end

  end
end