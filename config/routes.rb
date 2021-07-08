Rails.application.routes.draw do
  resource :social_media, only: [:show]

  root to: 'social_media#show'
end
