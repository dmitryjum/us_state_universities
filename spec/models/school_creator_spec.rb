require 'rails_helper'

describe SchoolCreator do
  describe ".insert_or_update_one" do
    subject {SchoolCreator.insert_or_update_one(data)}
    let(:school) {FactoryGirl.create :school, title: "The University of Alabama System"}
    let(:data) do
      {"title"=>"The University of Alabama System",
        "details"=>
        {"Established"=>"1969",
          "Type"=>"Public university system",
          "Endowment"=>"$1.23 billion (pooled)",
          "Chancellor"=>"Robert Witt",
          "Academic staff"=>"3,531",
          "Undergraduates"=>"43,297",
          "Postgraduates"=>"13,654",
          "Location"=>", Alabama, USA",
          "Campus"=>", Birmingham (UAB, Huntsville (UAH, Tuscaloosa (UA",
          "Website"=>"http://www.uasystem.ua.edu"}
       }
    end

    it 'creates new records' do
      expect {subject}.to change { School.count }.by 1
      expect(School.find_by_title(data["title"])).to be
    end

    it 'finds and updates existing records with new data' do
      expect(subject.title).to eq(data["title"])
      expect(subject.details).to eq(data["details"])
    end
  end

  describe ".insert_or_update" do
    subject {SchoolCreator.insert_or_update data}
    let!(:school1) {FactoryGirl.create :school, title: "The University of Alabama System"}
    let!(:school2) {FactoryGirl.create :school}
    let(:data) do
      [{"title"=>"The University of Alabama System",
        "details"=>
        {"Established"=>"1969",
          "Type"=>"Public university system",
          "Endowment"=>"$1.23 billion (pooled)",
          "Chancellor"=>"Robert Witt",
          "Academic staff"=>"3,531",
          "Undergraduates"=>"43,297",
          "Postgraduates"=>"13,654",
          "Location"=>", Alabama, USA",
          "Campus"=>", Birmingham (UAB, Huntsville (UAH, Tuscaloosa (UA",
          "Website"=>"http://www.uasystem.ua.edu"}
       },
      {"title"=>"Community College of Vermont",
        "details"=>
         {"Established"=>"1970",
          "Type"=>"Community college",
          "Chancellor"=>"Jeb Spaulding",
          "President"=>"Joyce Judy",
          "Administrative staff"=>"175",
          "Students"=>"6,000",
          "Location"=>"Headquarters in Montpelier, Vermont, USA",
          "Campus"=>"12 campuses across the state",
          "Website"=>"ccv.edu"}}]
    end

    it 'creates new records' do
      expect {subject}. to change { School.count }.by 1
      data_titles = data.map {|s| s["title"]}
      expect(School.where(title: data_titles).count).to eq 2
    end

    xit 'updates existing records' do
      data_titles = data.map {|s| s["title"]}
      data_details = data.map {|s| s["details"]}
      subject
      expect(School.where(title: data_titles).pluck(:details)).to eq data_details
    end

  end
end