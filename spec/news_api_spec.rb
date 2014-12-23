require 'spec_helper'

include Rack::Test::Methods

describe NewsApi do
  def app
    Rack::Lint.new(NewsApi.new)
  end

  it 'response with success' do
    get '/'
    expect last_response.ok?
  end

  describe 'stories' do
    describe 'GET `/stories`' do
      before { get '/stories' }

      it 'returns 200 status code' do
      end

      it 'returns list of existing stories' do
      end
    end

    describe 'GET `/stories/{id}`' do
      context 'when story exists' do
        it 'returns 200 status code' do
        end

        it 'returns story`s details' do
        end
      end

      context 'when story does not exist' do
        it 'returns 404 status code' do
        end
      end
    end

    describe 'POST `/stories`' do
      context 'when story is successfully created' do
        it 'returns 201 status code' do
        end

        it 'returns location header with new story' do
        end
      end

      context 'when story cannot be created' do
        it 'returns 400 status code' do
        end

        it 'returns error list' do
        end
      end
    end

    describe 'PATCH `/stories/{id}`' do
      context 'when story is successfully updated' do
        it 'returns 200 status code' do
        end
      end

      context 'when story cannot be updated' do
        it 'returns 400 status code' do
        end

        it 'returns error list' do
        end
      end

      context 'when story does not exist' do
        it 'returns 404 status code' do
        end
      end
    end
  end

  describe 'votes' do
    describe 'POST `/stories/{id}/votes`' do
      context 'when vote can be added' do
        it 'returns 201 status code for upvoting' do
        end

        it 'returns 201 status code for downvoting' do
        end
      end

      context 'when vote cannot be added' do
        it 'returns 400 status code' do
        end

        it 'returns error list' do
        end
      end

      context 'when story does not exist' do
        it 'returns 404 status code' do
        end
      end
    end

    describe 'DELETE `/stories/{id}/votes/{id}`' do
      context 'when vote is successfully deleted' do
        it 'returns 200 status code' do
        end
      end

      context 'when story does not exist' do
        it 'returns 404 status code' do
        end
      end
    end
  end

  describe 'users' do
    describe 'POST `/users`' do
      context 'when user is successfully created' do
        it 'returns 201 status code' do
        end
      end

      context 'when user cannot be created' do
        it 'returns 400 status code' do
        end

        it 'returns error list' do
        end
      end
    end
  end
end
