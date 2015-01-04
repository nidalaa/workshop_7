require 'spec_helper'

include Rack::Test::Methods

describe Sinatra::Application do
  def app
    Rack::Lint.new(NewsApi::App)
  end

  before(:each) do
    User.create!(id: 1, username: 'user', decrypted_password: 'pass')

    Story.create!(id: 1, title: 'Lorem ipsum', url: 'http://www.lipsum.com/', user_id: 1)
    Story.create!(id: 2, title: 'Lorem', url: 'http://www.lorem.com/', user_id: 1)

    Vote.create!(id: 1, user_id: 1, story_id: 2, point: 1)
  end

  describe 'stories' do
    let (:story_data) { {title: 'Title', url: 'http://www.url.com/'} }

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
        before { authorize 'user', 'pass' }

        context 'when story is successfully created' do
          before do
            post '/stories', story_data.to_json
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

          it 'adds record for authenticated user' do
            expect(Story.last.user_id).to eq(1)
          end
        end

        context 'when story cannot be created' do
          before do
            story_data = { title: "title"}
            post '/stories', story_data.to_json
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

      context 'without authenticated user' do
        it 'adds `WWW-Authenticate` header to response' do
          post '/stories', story_data.to_json

          expect(last_response.headers['WWW-Authenticate']).to eq 'Basic realm="Restricted Area"'
        end

        it 'returns 401 status code for wrong credentials' do
          authorize 'admin', 'wrong_pass'
          post '/stories', story_data.to_json

          expect(last_response.status).to eq 401
        end

        it 'returns 401 status code for request with empty credentials' do
          post '/stories', story_data.to_json

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
      context 'with authenticated user' do
        before { authorize 'user', 'pass' }

        context 'when vote can be added' do
          context 'upvoting' do
            before do
              vote_data = { point: 1 }
              put '/stories/1/vote', vote_data.to_json
            end

            it 'returns 201 status code' do
              expect(last_response.status).to eq 201
            end

            it 'increase score by one' do
              parsed_response = JSON.parse(last_response.body)
              expect(parsed_response['score']).to eq 1
            end
          end

          context 'downvoting' do
            before do
              vote_data = { point: -1 }
              put '/stories/1/vote', vote_data.to_json
            end

            it 'returns 201 status code' do
              expect(last_response.status).to eq 201
            end

            it 'decrease score by one' do
              parsed_response = JSON.parse(last_response.body)
              expect(parsed_response['score']).to eq -1
            end
          end
        end

        context 'when vote for particular user already exists' do
          context 'upvoting' do
            before do
              vote_data = { point: 1 }
              put '/stories/2/vote', vote_data.to_json
            end

            it 'returns 200 status code' do
              expect(last_response.status).to eq 200
            end

            it 'does not increase score' do
              parsed_response = JSON.parse(last_response.body)
              expect(parsed_response['score']).to eq 1
            end
          end

          context 'downvoting' do
            before do
              vote_data = { point: -1 }
              put '/stories/2/vote', vote_data.to_json
            end

            it 'returns 200 status code' do
              expect(last_response.status).to eq 200
            end

            it 'decrease score by two' do
              parsed_response = JSON.parse(last_response.body)
              expect(parsed_response['score']).to eq -1
            end
          end
        end

        context 'when vote cannot be added' do
          before do
            vote_data = { point: 99 }
            put '/stories/1/vote', vote_data.to_json
          end

          it 'returns 422 status code' do
            expect(last_response.status).to eq 422
          end

          it 'returns error list' do
            parsed_response = JSON.parse(last_response.body)
            expect(parsed_response.keys).to include 'errors'
            expect(parsed_response['errors'].keys).to include 'point'
          end
        end

        context 'when story does not exist' do
          it 'returns 404 status code' do
            vote_data = { point: 1 }
            put '/stories/999/vote', vote_data.to_json

            expect(last_response.status).to eq 404
          end
        end
      end

      context 'without authenticated user' do
        it 'returns 401 status code' do
          vote_data = { point: 1 }
          put '/stories/1/vote', vote_data.to_json

          expect(last_response.status).to eq 401
      end
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
          user_data = { username: "user", decrypted_password: "secret_password" }
          post '/users', user_data.to_json
        end

        it 'returns 201 status code' do
          expect(last_response.status).to eq 201
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
  end
end
