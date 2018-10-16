Rails.application.routes.draw do
  root 'posts#index'
  get 'ifttt/v1/status', to: 'ifttt#status'
  post 'ifttt/v1/test/setup', to: 'ifttt#setup'
  post 'ifttt/v1/triggers/new_post_with_hashtag', to: 'ifttt#new_post_with_hashtag'
  post 'ifttt/v1/actions/create_new_post', to: 'ifttt#create_new_post'
  resources :posts, except: :new
end
