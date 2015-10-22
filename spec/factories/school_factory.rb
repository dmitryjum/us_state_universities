FactoryGirl.define do
  factory :school do
    title {FFaker::Education.school_name}
    details do
        {"Established"=>"1969",
          "Type"=>FFaker::Lorem.word,
          "Endowment"=>"$1.23 billion (pooled)",
          "Chancellor"=>"Robert Witt",
          "Academic staff"=>"3,531",
          "Undergraduates"=>"43,297",
          "Postgraduates"=>"13,654",
          "Location"=> FFaker::Address.street_address,
          "Campus"=>", Birmingham (UAB, Huntsville (UAH, Tuscaloosa (UA",
          "Website"=>"http://www.uasystem.ua.edu"}
    end
  end
end