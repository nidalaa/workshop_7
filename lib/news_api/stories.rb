require_relative '../models/story'
require_relative 'helpers'

module NewsApi
  class Stories < Sinatra::Base
    include NewsApi::Helpers

    disable :show_exceptions

    error ActiveRecord::RecordNotFound do
      halt 404
    end

    get '/stories' do
      format_response(Story.all)
    end

    get '/stories/:id' do
      story = Story.find(params[:id])
      format_response(story)
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
        format_response({ errors: new_story.errors })
      end
    end

    patch '/stories/:id' do
      authenticate!
      story = Story.find(params[:id])
      check_update_permission(story)

      story.update(JSON.parse(request.body.read))

      if story.save
        status 200
      else
        status 422
        format_response({ errors: story.errors })
      end
    end

    get '/stories/:id/url' do
      story = Story.find(params[:id])
      redirect story.url, 303
    end

    def check_update_permission(story)
      if story.user_id != @user.id
        halt 422, {}, format_response({ errors: { not_owner: 'You can update only your own stories' } })
      end
    end
  end
end

