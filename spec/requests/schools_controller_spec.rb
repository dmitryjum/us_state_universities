require 'rails_helper'

describe Api::V1::SchoolsController do
  before do
    school1 = FactoryBot.create :school, title: "NYU"
    school2 = FactoryBot.create :school, title: "UCLA"
    school3 = FactoryBot.create :school, details: {
          "established"=>"1969",
          "type"=>"Public university system",
          "endowment"=>"$1.23 billion (pooled)",
          "chancellor"=>"Robert Witt",
          "academic staff"=>"3,531",
          "undergraduates"=>"43,297",
          "postgraduates"=>"13,654",
          "location"=>", Alabama, USA",
          "campus"=>", Birmingham (UAB, Huntsville (UAH, Tuscaloosa (UA",
          "website"=>"http://www.uasystem.ua.edu",
          "total" => "10000"
        }
    @requested_school_details = School.pluck(:details)
    host! 'api.example.com'
  end

  context 'requests the list of all schools with no params and gets it in xml' do
    it 'receives success status and response content type class of Mime::XML' do
      get api_v1_schools_path, headers: {'Accept' => Mime[:xml]}
      expect(response).to be_success
      expect(response.header['Content-Type']).to include 'application/xml'
    end
  end

  context 'requests the list of all schools with no params and gets it in json' do
    before :each do
      get api_v1_schools_path, headers: { "Accept" => "application/json" }
      @json_body = json_response
    end

    it 'receives success status' do
      expect(response).to be_success
    end

    it 'receives response with total of 3 school objects' do
      expect(@json_body.length).to eq 3
    end

    it 'receives response with list of schools that are in DB' do
      school_titles = School.pluck(:title)
      returned_titles = @json_body.map {|s| s["title"]}
      expect(school_titles).to eq returned_titles
    end
  end

  context "it looks up the school by 'title' param" do
    before :each do
      keyword = "n"
      @requested_schools = School.where("title ~* ?", keyword)
      get api_v1_schools_path(title: keyword), headers: { "Accept" => "application/json" }
      @json_body = json_response
    end

    it "receives response with the correct count of schools in the list by requested keyword" do
      expect(@json_body.length).to eq @requested_schools.length
    end

    it 'receives response with correct school titles in the list by requested keyword' do
      expect(@json_body.map {|s| s["title"]}.sort).to eq @requested_schools.pluck(:title).sort
    end
  end

  context "it finds schools by exact possible key in 'details' json of school object" do
    before :each do
      keyword = "type"
      get api_v1_schools_path(details: keyword), headers: { "Accept" => "application/json" }
      @json_body = json_response
    end

    it "receives response with the correct count of schools in the list by requested keyword" do
      expect(@json_body.length).to eq @requested_school_details.length
    end

    it 'receives response with correct school titles in the list by requested keyword' do
      expect(@json_body.map {|s| s["details"]}).to eq @requested_school_details
    end
  end

  context "it finds schools by arbitrary value case insensitive for specific key in 'details' json of school object" do
    before :each do
      get api_v1_schools_path(details: {"postgraduates" => "13"}), headers: { "Accept" => "application/json" }
      @json_body = json_response
    end

    it "receives response with the correct count of schools in the list by requested keyword" do
      expect(@json_body.length).to eq @requested_school_details.length
    end

    it 'receives response with correct school titles in the list by requested keyword' do
      expect(@json_body.map {|s| s["details"]}).to eq @requested_school_details
    end
  end

  context "it requests top twenty 'details' json keys for API query reference" do
    it "receives json with at least 20 k/v pairs, where keys are 'details' json keys and values are count of their appereances in DB" do
      get top_twenty_keys_api_v1_schools_path, headers: { "Accept" => "application/json" }
      json_body = json_response
      expect(json_body).to eq({
            "established"=> 3,
            "type"=> 3,
            "endowment"=> 3,
            "chancellor"=> 3,
            "academic staff"=> 3,
            "undergraduates"=> 3,
            "postgraduates"=> 3,
            "location"=> 3,
            "campus"=> 3,
            "website"=> 3,
            "total"=> 1
          })
    end
  end

end