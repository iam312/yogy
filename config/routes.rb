Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_out', to: 'devise/sessions#destroy'
  end
#  devise_scope :users do
#    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
#  end

  resources 'images' do
  end

  resources 'yogy', param: :title
  get 'yogy/:title/season/:season' => 'yogy#show', as: 'yogy_season'
  get 'yogy/:title/year/:year' => 'yogy#show', as: 'yogy_year'
  get 'yogy/:title/season/:season/year/:year' => 'yogy#show', as: 'yogy_season_year'

  get 'index_v2', to: 'yogy#index_v2'
  get 'about', to: 'yogy#about'

  get '/dn/:image_id/:type' =>'dn#show', as: 'dn'

  root to: 'yogy#index_v2'
end
