require 'rails_helper'

describe SchoolCreator do
  describe ".insert_or_update" do
    subject {SchoolCreator.insert_or_update(data)}
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
      let(:school) {FactoryGirl.create :school, title: "The University of Alabama System"}
      expect {subject}.to eq data
    end
  end
end