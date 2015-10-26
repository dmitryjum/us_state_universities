module API
  module V1
    class SchoolsController < ApplicationController

      def index
        if params[:title].present?
          @schools = School.where_by_title params[:title]
        elsif params[:details].present?
          @schools = School.where_by_details params[:details]
        else
          @schools = School.all
        end
        render json: @schools, status: 200
      end

    end
  end
end