module Paginatable
  extend ActiveSupport::Concern

  included do
    scope :paginate, -> (params = {}) do
      per_page = params[:per_page].nil? ? 9 : params[:per_page].to_i
      page = params[:page].nil? ? 1 : params[:page].to_i
    	entries_count = self.count
    	pages_per_limit = entries_count / per_page + 1
      records = entries_count <= per_page ? self.all.order('title ASC') :
                self.offset((page - 1) * per_page).order('title ASC').limit(per_page)
    	{
    		records: records,
    		entries_count: entries_count,
    		pages_per_limit: pages_per_limit,
    		page: page
    	}
    end
  end
end