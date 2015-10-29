require 'rails_helper'

describe School do
  describe ".top_twenty_keys" do
    subject {School.top_twenty_keys}
    before do
      FactoryGirl.create_pair :school
      FactoryGirl.create :school, details: {
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
    end
    let(:top_keys_hash) do
      {
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
      }
    end
    it "returns hash with at least top 20 keys in 'details' json as keys and count of their appereance as values in decending order" do
      expect(subject).to eq top_keys_hash
    end
  end
end