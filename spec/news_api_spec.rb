require 'spec_helper'

include Rack::Test::Methods

describe Sinatra::Application do
  def app
    Rack::Lint.new(NewsApi)
  end

  describe 'stories' do
    describe 'GET `/stories`' do
      before { get '/stories' }

      it 'returns 200 status code' do
        expect last_response.ok?
      end

      it 'returns list of existing stories' do
        expected_json = '{"stories":[{"id":"1","title":"Lorem ipsum","url":"http://www.lipsum.com/"},{"id":"2","title":"Lorem","url":"http://www.lorem.com/"}]}'
        expect(last_response.body).to eq(expected_json) 
      end
    end

    describe 'GET `/stories/{id}`' do
      context 'when story exists' do
        before { get '/stories/1' }

        it 'returns 200 status code' do
          expect last_response.ok?
        end

        it 'returns story`s details' do
          expected_json = '{"id":"1","title":"Lorem ipsum","url":"http://www.lipsum.com/"}'
          expect(last_response.body).to eq(expected_json)
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
        it 'returns 201 status code'

        it 'returns location header with new story'
      end

      context 'when story cannot be created' do
        it 'returns 400 status code'

        it 'returns error list'
      end
    end

    describe 'PATCH `/stories/{id}`' do
      context 'when story is successfully updated' do
        it 'returns 200 status code'
      end

      context 'when story cannot be updated' do
        it 'returns 400 status code'

        it 'returns error list'
      end

      context 'when story does not exist' do
        it 'returns 404 status code'
      end
    end
  end

  describe 'votes' do
    describe 'POST `/stories/{id}/votes`' do
      context 'when vote can be added' do
        it 'returns 201 status code for upvoting'

        it 'returns 201 status code for downvoting'
      end

      context 'when vote cannot be added' do
        it 'returns 400 status code'

        it 'returns error list'
      end

      context 'when story does not exist' do
        it 'returns 404 status code'
      end
    end

    describe 'DELETE `/stories/{id}/votes/{id}`' do
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
        it 'returns 400 status code'

        it 'returns error list'
      end
    end
  end
end
