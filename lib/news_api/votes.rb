require_relative '../models/story'
require_relative '../models/vote'
require_relative 'helpers'

module NewsApi
  class Votes < Sinatra::Base
    include NewsApi::Helpers

    put '/stories/:id/vote' do
      authenticate!
      halt 404 unless Story.find_by(id: params[:id])

      vote = Vote.find_or_create_by(user_id: @user.id, story_id: params[:id])
      vote.point = JSON.parse(request.body.read)['point']
      is_new = !vote.id

      if vote.save
        status (is_new ? 201 : 200)
        { score: Vote.by_story(params[:id]).sum(:point) }.to_json
      else
        status 422
        { errors: vote.errors }.to_json
      end
    end

    delete '/stories/:id/vote' do
      authenticate!
      halt 404 unless Story.find_by(id: params[:id])

      vote = Vote.find_by(user_id: @user.id, story_id: params[:id])

      if vote
        vote.destroy
        status 200
        { score: Vote.by_story(params[:id]).sum(:point) }.to_json
      else
        halt 404
      end
    end

  end
end
