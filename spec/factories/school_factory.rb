FactoryGirl.define do
  factory :school do
    title {FFaker::Lorem.word}
    details do
        {
          "established"=>"1969",
          "type"=>FFaker::Lorem.word,
          "endowment"=>"$1.23 billion (pooled)",
          "chancellor"=>"Robert Witt",
          "academic staff"=>"3,531",
          "undergraduates"=>"43,297",
          "postgraduates"=>"13,654",
          "location"=> FFaker::Address.street_address,
          "campus"=>", Birmingham (UAB, Huntsville (UAH, Tuscaloosa (UA",
          "website"=>"http://www.uasystem.ua.edu"
        }
    end
  end
end