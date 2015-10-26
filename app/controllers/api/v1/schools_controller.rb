module API
  module V1
    class SchoolsController < ApplicationController

      def index
        if params[:title].present?
          @schools = School.where_title_is params[:title]
        elsif params[:details].present?
          @schools = School.where_details_key_is params[:details]
        else
          @schools = School.all
        end
        render json: @schools, status: 200
      end

      def find_by_details

      end

    end
  end
end