class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


    def init_fb_graph_api
        @oauth = Koala::Facebook::OAuth.new("420192248003899", "9378211203af4d60dbeb410ad93957a2")
        oauth_access_token = @oauth.get_app_access_token

        @graph = Koala::Facebook::API.new(oauth_access_token)
    end

end
