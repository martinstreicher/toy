class SocialMediaController < ApplicationController
  def show
    result = SocialMediaInteractor.call
    render json: result.posts, status: :ok
  end
end
