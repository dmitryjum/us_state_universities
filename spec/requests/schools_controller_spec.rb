require 'rails_helper'

describe Api::V1::SchoolsController do
  before do
    user = User.create email: "email@example.com", password: "password", password_confirmation: "password"
    school1 = FactoryBot.create :school, title: "NYU"
    school2 = FactoryBot.create :school, title: "UCLA"
    school3 = FactoryBot.create :school, title: "Columbia", details: {
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
    @valid_auth_header = "Bearer #{JsonWebToken.encode({user_id: user.id})}"
    host! 'api.example.com'
  end

  context 'requests the list of all schools with no params and gets it in xml' do
    it 'receives success status and response content type class of Mime::XML' do
      get api_v1_schools_path, headers: {'Accept' => Mime[:xml]}
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/xml'
    end
  end

  context 'requests the list of all schools with no params and gets it in json' do
    before :each do
      get api_v1_schools_path, headers: { "Accept" => "application/json" }
      @json_body = json_response
    end

    it 'receives success status' do
      expect(response).to be_successful
    end

    it 'receives response as the object with "records", "entries_count", "pages_per_limit", "page" keys' do
      expect(@json_body.keys).to eq ["records", "entries_count", "pages_per_limit", "page"]
    end

    it 'receives response with list of schools that are in DB by the "records" key in the response object' do
      school_titles = School.pluck(:title)
      returned_titles = @json_body['records'].map {|s| s["title"]}
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
      expect(@json_body['records'].length).to eq @requested_schools.length
    end

    it 'receives response with correct school titles in the list by requested keyword' do
      expect(@json_body['records'].map {|s| s["title"]}.sort).to eq @requested_schools.pluck(:title).sort
    end
  end

  context "it finds schools by exact possible key in 'details' json of school object" do
    before :each do
      keyword = "type"
      get api_v1_schools_path(details: keyword), headers: { "Accept" => "application/json" }
      @json_body = json_response
    end

    it "receives response with the correct count of schools in the list by requested keyword" do
      expect(@json_body['records'].length).to eq @requested_school_details.length
    end

    it 'receives response with correct school titles in the list by requested keyword' do
      expect(@json_body['records'].map {|s| s["details"]}).to eq @requested_school_details
    end
  end

  context "it finds schools by arbitrary value case insensitive for specific key in 'details' json of school object" do
    before :each do
      get api_v1_schools_path(details: {"postgraduates" => "13"}), headers: { "Accept" => "application/json" }
      @json_body = json_response
    end

    it "receives response with the correct count of schools in the list by requested keyword" do
      expect(@json_body['records'].length).to eq @requested_school_details.length
    end

    it 'receives response with correct school titles in the list by requested keyword' do
      expect(@json_body['records'].map {|s| s["details"]}).to eq @requested_school_details
    end
  end

  context "it finds schools by any search term using full text search functionality" do
    it "receives schools where search term words are mentioned" do
      get search_api_v1_schools_path(term: "type public"), headers: { "Accept" => "application/json" }
      expect(json_response['records'].count).to be 1
      expect(json_response['records'].first["title"]).to eq "Columbia"
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

  context "it requests paginated result" do
    it 'requests 2nd page with 2 schools per page and receives 1 school from 3' do
      get api_v1_schools_path(per_page: 2, page: 2), headers: { "Accept" => "application/json" }
      expect(json_response['records'].length).to be 1
      expect(json_response['records'][0]['title']).to eq("UCLA")
    end

    it 'requests 2nd page and forgets to specify the limit and receives 2nd or last page with default of max 9 records per page' do
      get api_v1_schools_path(page: 2), headers: { "Accept" => "application/json" }
      expect(json_response['records'].length).to be 3
      expect(json_response['records'].map{|s| s['title']}).to eq ["Columbia", "NYU", "UCLA"]
    end

    it 'recieves json with "records", "entries_count", "pages_per_limit" and "page" keys' do
      get api_v1_schools_path(per_page: 2, page: 2), headers: { "Accept" => "application/json" }
      expect(json_response.keys).to eq(["records", "entries_count", "pages_per_limit", "page"])
    end
  end

  context 'it updates a school' do
    before :each do
      @first_school = School.first
    end

    it 'found by id' do
      patch api_v1_school_path(id: @first_school.id, school: {title: 'University of Magic'}), headers: { "Authorization": @valid_auth_header }
      expect(response.status).to be 201
      expect(json_response['title']).to eq(School.find(@first_school.id).title)
    end

    context 'fails to update a school' do
      it 'fails title validation' do
        @last_school = School.last
        patch api_v1_school_path(id: @first_school.id, school: {title: @last_school.title}), headers: { "Authorization": @valid_auth_header }
        expect(response.status).to be 422
        expect(json_response['title'].first).to eq "has already been taken"
      end

      it 'fails authentication' do
        patch api_v1_school_path(id: @first_school.id, school: {title: 'University of Magic'}), headers: { "Authorization": 'asdf' }
        expect(response.status).to be 401
        expect(json_response['error']).to eq "Invalid Request or Unauthorized"
      end
    end
  end

  context 'it creates a new school' do
    it 'succeeds creating a new school' do
      post api_v1_schools_path(school: {title: "New Modern School", details: {"established" => "1966", "mascot" => "Eagle", "location" => "San Juan, PR"}}), headers: { "Authorization": @valid_auth_header }
      expect(response.status).to be 201
      expect(School.count).to be 4
      expect(json_response["details"]).to eq(School.find_by_title("New Modern School").details)
    end

    it 'fails authentication' do
      post api_v1_schools_path(school: {title: "New Modern School", details: {"established" => "1966", "mascot" => "Eagle", "location" => "San Juan, PR"}})
      expect(response.status).to be 401
      expect(json_response['error']).to eq "Invalid Request or Unauthorized"
    end

    it 'fails title validation' do
      @last_school = School.last
      post api_v1_schools_path(school: {title: @last_school.title, details: {"established" => "1966", "mascot" => "Eagle", "location" => "San Juan, PR"}}), headers: { "Authorization": @valid_auth_header }
      expect(response.status).to be 422
      expect(json_response['title'].first).to eq "has already been taken"
    end
  end

end