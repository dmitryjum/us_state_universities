module Paginatable
  extend ActiveSupport::Concern

  included do
    scope :paginate, -> (params = {}) do
      per_page = params[:per_page].nil? ? 10 : params[:per_page]
      page = params[:page].nil? ? 1 : params[:per_page]
    	entries_count = self.count
    	pages_per_limit = entries_count / per_page + 1
    	{
    		records: self.offset((page - 1) * per_page).order('title ASC').limit(per_page),
    		entries_count: entries_count,
    		pages_per_limit: pages_per_limit,
    		page: page
    	}.with_indifferent_access
    end
  end
end