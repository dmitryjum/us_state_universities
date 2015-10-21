class SchoolCreator
  def self.insert_or_update school
    binding.pry
    title = school.delete("title")
    details = school
    school  = School.find_or_create_by_title title
    school.update(details: details)
  end
end