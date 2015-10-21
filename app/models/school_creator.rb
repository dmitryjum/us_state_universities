class SchoolCreator
  def self.insert_or_update school
    school  = School.find_or_create_by(title: school["title"])
    school.update(details: school["details"])
  end
end