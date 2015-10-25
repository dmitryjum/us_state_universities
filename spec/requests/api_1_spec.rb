require 'rails_helper'

describe API::V1::SchoolsController do
  before do
    factory_schools = FactoryGirl.create_list(:school, 2)
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

end