module API
  module V1
    class SchoolsController < ApplicationController

      def index
        if params[:title].present?
          @schools = School.where_title_is params[:title]
        elsif params[:details].present?
          if params[:details].is_a? Hash
            @schools = School.where_details_are params[:details]
          else
            @schools = School.where_details_key_is params[:details]
          end
        else
          @schools = School.all
        end
        render json: @schools, status: 200
      end

      def twenty_pop_keys
      end

    end
  end
end