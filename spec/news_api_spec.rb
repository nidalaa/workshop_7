require 'spec_helper'

include Rack::Test::Methods

describe NewsApi do
  def app
    NewsApi.new
  end

  it 'response with success' do
    get '/'
    expect last_response.ok?
  end
end
