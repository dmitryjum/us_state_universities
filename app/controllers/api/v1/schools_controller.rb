module API
  module V1
    class SchoolsController < ApplicationController

      def index
        @schools = School.where_params_are params
        render json: @schools, status: 200
      end

      def top_twenty_keys
        @keys = School.top_twenty_keys
        render json: @keys, status: 200
      end

    end
  end
end