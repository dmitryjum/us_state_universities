module Paginatable
  extend ActiveSupport::Concern

  included do
    scope :paginate, -> (params = {}) do
      response = {records: self, entries_count: self.count, pages_per_limit: 1, page: 1}
      unless params[:per_page].nil? && params[:page].nil?
        per_page = params[:per_page].nil? ? 9 : params[:per_page].to_i
        response[:page] = params[:page].nil? ? 1 : params[:page].to_i
      	resonse[:pages_per_limit] = response[:entries_count] / per_page + 1
        response[:records] = response[:entries_count] <= per_page ? self.all.order('title ASC') :
                  self.offset((page - 1) * per_page).order('title ASC').limit(per_page)
        response
      end
      response
    end
  end
end