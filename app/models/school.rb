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
    {}.tap do |key_counts|
      uniq_details_keys.each {|k| key_counts[k] = 0}
      details_keys.each {|k| key_counts[k] += 1 if uniq_details_keys.include? k}
      key_counts.to_a.sort_by {|a| a.last}.reverse
    end.first(20).to_h
  end

  def self.insert_or_update_one new_school
    current_school = find_or_create_by(title: new_school["title"])
    current_school.update(details: new_school["details"])
    current_school
  end

  private

  def self.details_keys
    @not_uniq_keys ||= pluck(:details).flat_map(&:keys)
  end

  def self.uniq_details_keys
    @uniq_keys ||= details_keys.uniq
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