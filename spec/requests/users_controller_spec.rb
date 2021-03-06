require 'rails_helper'

describe Api::V1::UsersController do
	context 'it creates a user' do
		it 'creates user successfuly' do
			user = {
				email: 'test@email.com',
				password: 'test',
				password_confirmation: 'test'
			}
			post api_v1_users_path(user: user)
			expect(response.status).to be 201
			expect(json_response['status']).to eq "User created successfully"
		end

		it 'fails to create a user because of wrong email' do
			user = {
				email: 'testemail.com',
				password: 'test',
				password_confirmation: 'test'
			}
			post api_v1_users_path(user: user)
			expect(response.status).to be 400
			expect(json_response['errors'].first).to eq "Email is invalid"
		end
	end

	context 'it logs user in' do
		before :each do
			@user = User.create email: "email@example.com", password: "password", password_confirmation: "password"
			@jwt = JsonWebToken.encode(user_id: @user.id)
		end

		describe 'logs user in successfully' do
			it 'returns auth_token' do
				post login_api_v1_users_path(email: "email@example.com", password: "password")
				expect(response).to be_successful
				expect(json_response['auth_token']).to eq(@jwt)
			end

			it 'returns users email' do
				post login_api_v1_users_path(email: "email@example.com", password: "password")
				expect(json_response['email']).to eq("email@example.com")
			end
		end

		describe 'is_authenticated' do
			it 'fails to verify Auth' do
	      get is_authenticated_api_v1_users_path
	      expect(response.status).to be 401
	      expect(json_response['error']).to eq "Invalid Request or Unauthorized"
			end

			it 'succeds to verify Auth' do
				valid_auth_header = "Bearer #{@jwt}"
				get is_authenticated_api_v1_users_path, headers: { "Authorization": valid_auth_header }
				expect(response.status).to be 200
				expect(json_response['email']).to eq(@user.email)
			end
		end

		it 'fails to log user in' do
			post login_api_v1_users_path(email: "email@example.com", password: "bla")
			expect(response.status).to be 401
			expect(json_response['error']).to eq "Invalid username / password"
		end
	end
end