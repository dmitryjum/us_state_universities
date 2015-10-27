class School < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title

  scope :where_title_is, -> (keyword) { where("title ~* ?", keyword) }
  scope :where_details_key_is, -> (keyword) { where("details ? '#{keyword}'") }
  scope :where_details_are, ->(details) { where("details ->> '#{details.first.first}' ~~* '%#{details.first.last}%'")}


  def self.where_params_are params
    if params[:title].present?
      where_title_is params[:title]
    elsif params[:details].present?
      params[:details].is_a?(Hash) ? where_details_are(params[:details]) : where_details_key_is(params[:details])
    else
      all
    end
  end

  def self.top_twenty_keys
  end

  private

  def uniq_details_keys
  end

  # example of regex search in jsonb "details ->> 'Type' ~~* 'public'"
  # LIKE (~~) is simple and fast but limited in its capabilities.
  # ILIKE (~~*) the case insensitive variant.
  # pg_trgm extends index support for both.

  # ~ (regular expression match) is powerful but more complex and may be slow for anything more than basic expressions.

  # SIMILAR TO is just pointless. A peculiar halfbreed of LIKE and regular expressions. I never use it. Explanation below.

  # % is the "similarity" operator, provided by the additional module pg_trgm.

  # @@ is the text search operator.
end