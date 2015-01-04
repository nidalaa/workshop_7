require_relative '../models/story'
require_relative 'helpers'

module NewsApi
  class Stories < Sinatra::Base
    include NewsApi::Helpers

    get '/stories' do
      respond_with_xml? ? Story.all.to_xml : Story.all.to_json
    end

    get '/stories/:id' do
      if story = Story.find_by(id: params[:id])
        respond_with_xml? ? story.to_xml : story.to_json
      else
        halt 404
      end
    end

    post '/stories' do
      authenticate!

      new_story = Story.create(JSON.parse(request.body.read).merge(user_id: @user.id))

      if new_story.save
        status 201
        headers \
          "Location" => "/stories/#{new_story.id}"
      else
        status 422
        respond_with_xml? ? { errors: new_story.errors }.to_xml : { errors: new_story.errors }.to_json
      end
    end

    patch '/stories/:id' do
      authenticate!

      story = Story.find_by(id: params[:id])
      can_update?(story)
      story.update(JSON.parse(request.body.read))

      if story.save
        status 200
      else
        status 422
        respond_with_xml? ? { errors: story.errors }.to_xml : { errors: story.errors }.to_json
      end
    end

    get '/stories/:id/url' do
      if story = Story.find_by(id: params[:id])
        redirect story.url
      else
        halt 404
      end
    end

    def can_update?(story)
      halt 404 unless story
      if story.user_id != @user.id
        errors = { errors: { not_owner: 'You can update only your own stories' } }
        halt 422, {}, respond_with_xml? ? errors.to_xml :  errors.to_json
      end
    end
  end
end

