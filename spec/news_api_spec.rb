require 'spec_helper'

include Rack::Test::Methods

describe Sinatra::Application do
  def app
    Rack::Lint.new(NewsApi::App)
  end

  before(:each) do
    Story.create!(id: 1, title: 'Lorem ipsum', url: 'http://www.lipsum.com/')
    Story.create!(id: 2, title: 'Lorem', url: 'http://www.lorem.com/')
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
      context 'when story is successfully created' do
        before do
          story_data = { title: 'Title', url: 'http://www.url.com/' }
          post '/stories', story_data.to_json
        end

        it 'returns 201 status code' do
          expect(last_response.status).to eq 201
        end

        it 'returns location header with new story' do
          expect(last_response.headers['location']).to eq '/stories/3'
        end

        it 'adds record to database' do
          expect(Story.all.count).to eq(3)
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
          expect(last_response.body).to include '"url":["can\'t be blank"]'
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
        it 'returns 201 status code'
      end

      context 'when user cannot be created' do
        it 'returns 422 status code'

        it 'returns error list'
      end
    end
  end
end
