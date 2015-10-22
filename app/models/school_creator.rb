class SchoolCreator
  def self.insert_or_update_one new_school
    current_school = School.find_or_create_by(title: new_school["title"])
    current_school.update(details: new_school["details"])
    current_school
  end

  def self.insert_or_update school_list
    schools = School.create school_list
    titles = schools.map(&:title)
    details = schools.map(&:details)
    School.where(title: titles).update_all(details: details)
  end
end