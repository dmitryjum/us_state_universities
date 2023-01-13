require 'rails_helper'

describe School do
  describe ".insert_or_update_one" do
    subject {School.insert_or_update_one(data)}
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
    context "it creates new records, finds and updates existing ones" do
      it 'it increases schools count by 1' do
        expect {subject}.to change { School.count }.by 1
      end

      it 'creates school with correct title' do
        subject
        expect(School.find_by_title(data["title"])).to be
      end

      it 'it correctly updates school title' do
        expect(subject.title).to eq(data["title"])
      end

      it 'it correctly updates school details' do
        expect(subject.details).to eq(data["details"])
      end

    end
  end

end