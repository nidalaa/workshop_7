require 'spec_helper'

include Rack::Test::Methods

describe Sinatra::Application do
  def app
    Rack::Lint.new(NewsApi::App)
  end

  before(:each) do
    User.create!(id: 1, username: 'user', password: 'pass')

    Story.create!(id: 1, title: 'Lorem ipsum', url: 'http://www.lipsum.com/', user_id: 1)
    Story.create!(id: 2, title: 'Lorem', url: 'http://www.lorem.com/', user_id: 1)
  end

  describe 'stories' do
    describe 'GET `/stories`' do
      before { get '/stories' }

      it 'returns 200 status code' do
        expect last_response.ok?
      end

      it 'returns list of existing stories' do
        expected_titles = ["Lorem ipsum", "Lorem"]

        stories = JSON.parse(last_response.body)
        expect(stories.map { |story| story["title"] }).to eq(expected_titles)
      end
    end

    describe 'GET `/stories/{id}`' do
      context 'when story exists' do
        before { get '/stories/1' }

        it 'returns 200 status code' do
          expect last_response.ok?
        end

        it 'returns story`s details' do
          story = JSON.parse(last_response.body)
          expect(story["title"]).to eq("Lorem ipsum")
        end
      end

      context 'when story does not exist' do
        it 'returns 404 status code' do
          get '/stories/9999'
          expect(last_response.status).to eq 404
        end
      end
    end

    describe 'POST `/stories`' do
      context 'with authenticated user' do
        before { authorize 'admin', 'secret' }

        context 'with logged-in user' do
          context 'when story is successfully created' do
            before do
              story_data = { title: 'Title', url: 'http://www.url.com/' }
              post '/stories', story_data.to_json, 'rack.session' => { :user_id => '1' }
            end

            it 'returns 201 status code' do
              expect(last_response.status).to eq 201
            end

            it 'returns location header with new story' do
              expect(last_response.headers['Location']).to eq '/stories/3'
            end

            it 'adds record to database' do
              expect(Story.all.count).to eq(3)
            end

            it 'adds record for logged-in user' do
              expect(Story.last.user_id).to eq(1)
            end
          end

          context 'when story cannot be created' do
            before do
              story_data = { title: "title"}
              post '/stories', story_data.to_json, 'rack.session' => { :user_id => '1' }
            end

            it 'returns 422 status code' do
              expect(last_response.status).to eq 422
            end

            it 'returns error list' do
              parsed_response = JSON.parse(last_response.body)
              expect(parsed_response.keys).to include 'errors'
              expect(parsed_response['errors'].keys).to include 'url'
            end
          end
        end

        context 'without logged-in user' do
          before do
            story_data = { title: 'Title', url: 'http://www.url.com/' }
            post '/stories', story_data.to_json
          end

          it 'returns 403 status code' do
            expect(last_response.status).to eq 403
          end

          it 'returns location header with login path' do
            expect(last_response.headers['Location']).to eq '/users/login'
          end
        end
      end

      context 'without authenticated user' do
        it 'returns 401 status code for wrong credentials' do
          authorize 'admin', 'wrong_pass'
          story_data = { title: 'Title', url: 'http://www.url.com/' }
          post '/stories', story_data.to_json, 'rack.session' => { :user_id => '1' }

          expect(last_response.status).to eq 401
        end

        it 'returns 401 status code for request with empty credentials' do
          story_data = { title: 'Title', url: 'http://www.url.com/' }
          post '/stories', story_data.to_json, 'rack.session' => { :user_id => '1' }

          expect(last_response.status).to eq 401
        end
      end
    end

    describe 'PATCH `/stories/{id}`' do
      context 'when story is successfully updated' do
        it 'returns 200 status code'
      end

      context 'when story cannot be updated' do
        it 'returns 422 status code'

        it 'returns error list'
      end

      context 'when story does not exist' do
        it 'returns 404 status code'
      end
    end
  end

  describe 'votes' do
    describe 'PUT `/stories/{id}/vote`' do
      context 'when vote can be added' do
        it 'returns 201 status code for upvoting'

        it 'returns 201 status code for downvoting'
      end

      context 'when vote can be changed' do
        it 'returns 200 status code for upvoting'

        it 'returns 200 status code for downvoting'
      end

      context 'when vote cannot be added' do
        it 'returns 422 status code'

        it 'returns error list'
      end

      context 'when story does not exist' do
        it 'returns 404 status code'
      end
    end

    describe 'DELETE `/stories/{id}/vote`' do
      context 'when vote is successfully deleted' do
        it 'returns 200 status code'
      end

      context 'when story does not exist' do
        it 'returns 404 status code'
      end
    end
  end

  describe 'users' do
    describe 'POST `/users`' do
      context 'when user is successfully created' do
        before do
          user_data = { username: "user", password: "secret_password" }
          post '/users', user_data.to_json
        end

        it 'returns 201 status code' do
          expect(last_response.status).to eq 201
        end

        it 'automatically sets user session cookie' do
          expect(last_request.env['rack.session']['user_id']).to eq 2
        end
      end

      context 'when user cannot be created' do
        before do
          user_data = { username: "user" }
          post '/users', user_data.to_json
        end

        it 'returns 422 status code' do
          expect(last_response.status).to eq 422
        end

        it 'returns error list' do
          parsed_response = JSON.parse(last_response.body)
          expect(parsed_response.keys).to include 'errors'
          expect(parsed_response['errors'].keys).to include 'password'
        end
      end
    end

    describe 'POST `/users/login`' do
      context 'with correct user data' do
        before do
          login_data = { username: 'user', password: 'pass' }.to_json
          post 'users/login', login_data
        end
        it 'returns 201 status code' do
          expect(last_response.status).to eq 201
        end

        it 'sets user session cookie' do
          # it should be hashed but for now I prefer to make it as simple as possible
          expect(last_request.env['rack.session']['user_id']).to eq 1
        end
      end

      context 'with incorrect user data' do
        before do
          login_data = { username: 'user', password: 'wrong_pass' }.to_json
          post 'users/login', login_data
        end

        it 'returns 403 status code' do
          expect(last_response.status).to eq 403
        end

        it 'leaves user session empty' do
          expect(last_request.env['rack.session']['user_id']).to be_nil
        end
      end
    end

    describe 'DELETE `/users/logout`' do
      it 'removes user session' do
        delete 'users/logout'
        expect(last_request.env['rack.session']['user_id']).to be_nil
      end
    end
  end
end
