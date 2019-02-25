require 'rails_helper'

describe User, type: :model do
  describe "#downcase_email" do
  	subject {FactoryBot.create :user, email: "Hello World@email.com"}
  	it "downcases email address and removes spaces" do
  		expect(subject.email).to eq "helloworld@email.com"
  	end
  end

  describe "#generate_confirmation_instructions" do
  	before :each do
	  	@user = FactoryBot.create :user, email: "Hello World@email.com"
  	end

  	it "creates confirmation token as random string with 20 characters" do
  		expect(@user.confirmation_token.class).to be String
  		expect(@user.confirmation_token.length).to be 20
  	end

  	it "adds confirmation_sent_at record as TimeWithZone class" do
  		expect(@user.confirmation_sent_at.class).to be ActiveSupport::TimeWithZone
  	end
  end
end
