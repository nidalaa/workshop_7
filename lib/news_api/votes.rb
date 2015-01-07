require_relative '../models/story'
require_relative '../models/vote'
require_relative 'helpers'

module NewsApi
  class Votes < Sinatra::Base
    include NewsApi::Helpers

    disable :show_exceptions

    error ActiveRecord::RecordNotFound do
      halt 404
    end

    put '/stories/:id/vote' do
      authenticate!

      vote = Vote.find_or_initialize_by(user_id: @user.id, story: Story.find(params[:id]))
      vote.point = JSON.parse(request.body.read)['point']
      is_new = vote.new_record?

      if vote.save
        status (is_new ? 201 : 200)
      else
        status 422
        { errors: vote.errors }.to_json
      end
    end

    delete '/stories/:id/vote' do
      authenticate!

      vote = Vote.find_by(user_id: @user.id, story_id: params[:id])

      if vote
        vote.destroy
        status 200
      else
        halt 404
      end
    end

  end
end
