require 'rails_helper'

describe API::V1::SchoolsController do
  before do
    school1 = FactoryGirl.create :school, title: "NYU"
    school2 = FactoryGirl.create :school, title: "UCLA"
    host! 'api.example.com'
  end

  context 'requests the list of all schools with no params and gets it' do
    it 'receives success status' do
       get api_v1_schools_path, {}, { "Accept" => "application/json" }
       expect(response).to be_success
    end

    it 'receives response with total of 2 school objects' do
      get api_v1_schools_path, {}, { "Accept" => "application/json" }
      body = JSON.parse(response.body)
      expect(body.length).to eq 2
    end

    it 'receives response with list of schools that are in DB' do
      school_titles = School.pluck(:title)
      get api_v1_schools_path, {}, { "Accept" => "application/json" }
      body = JSON.parse(response.body)
      returned_titles = body.map {|s| s["title"]}
      expect(school_titles).to eq returned_titles
    end
  end

  context "it looks up the school by 'title' param" do
    it "receives response with the correct count of schools in the list by requested keyword" do
      keyword = "n"
      requested_schools = School.where_title_is keyword
      get api_v1_schools_path(title: keyword), {}, { "Accept" => "application/json" }
      body = JSON.parse(response.body)
      expect(body.length).to eq requested_schools.length
    end

    it 'receives response with correct school titles in the list by requested keyword' do
      keyword = "n"
      requested_schools = School.where_title_is keyword
      get api_v1_schools_path(title: "n"), {}, { "Accept" => "application/json" }
      body = JSON.parse(response.body)
      expect(body.map {|s| s["title"]}.sort).to eq requested_schools.pluck(:title).sort
    end
  end

  context "it finds schools by exact possible key in 'details' json of school object" do
    it "receives response with the correct count of schools in the list by requested keyword" do
      keyword = "Type"
      requested_schools = School.where_details_key_is keyword
      get api_v1_schools_path(details: keyword), {}, { "Accept" => "application/json" }
      body = JSON.parse(response.body)
      expect(body.length).to eq requested_schools.length
    end

    it 'receives response with correct school titles in the list by requested keyword' do
      keyword = "Type"
      requested_schools = School.where_details_key_is keyword
      get api_v1_schools_path(details: keyword), {}, { "Accept" => "application/json" }
      body = JSON.parse(response.body)
      expect(body.map {|s| s["details"]}.sort).to eq requested_schools.pluck(:details).sort
    end
  end

end