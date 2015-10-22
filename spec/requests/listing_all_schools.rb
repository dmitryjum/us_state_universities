describe API::V1::SchoolsController, type: :controller do
  setup {host! 'api.example.com'}
  it 'returns all schools' do
    factory_schools = FactoryGirl.create_list(:school, 2)
    school_titles = School.pluck(:title)
    get "/api/v1/schools", {}, { "Accept" => "application/json" }

    body = JSON.parse(response.body)

    expect(response).to be_success
    expect(body['schools'].length).to eq 10
    returned_titles = body.map {|s| s["title"]}
    expect(school_titles).to eq returned_titles
  end
end