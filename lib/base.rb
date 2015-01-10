require 'sinatra/base'

module NewsApi
  class Base < Sinatra::Base

    disable :show_exceptions

    error ActiveRecord::RecordNotFound do
      halt 404
    end
  end
end
