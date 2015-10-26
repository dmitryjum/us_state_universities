class School < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title

  scope :where_by_title, -> (keyword) { where("title ~* ?", keyword) }
end