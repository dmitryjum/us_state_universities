class SchoolCreator
  def self.insert_or_update_one new_school
    current_school = School.find_or_create_by(title: new_school["title"])
    current_school.update(details: new_school["details"])
    current_school
  end
end