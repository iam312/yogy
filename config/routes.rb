Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_out', to: 'devise/sessions#destroy'
  end
#  devise_scope :users do
#    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
#  end

  resources 'images'
  get 'images/filter/user/:user_id' => 'images#filter_by_user', as: 'image_filter_by_user'
  get 'images/:id/nav/:nav' => 'images#show', as: 'image_nav'
  post 'images/:id/save_yogies' => 'images#ajax_save_yogies', as: 'image_save_yogies'
  post 'images/:id/save_desc' => 'images#ajax_save_description', as: 'image_save_description'
  post 'images/:id/like' => 'images#ajax_like', as: 'image_like'
  post 'images/:id/dislike' => 'images#ajax_dislike', as: 'image_dislike'
  post 'images/:id/cancel_like' => 'images#ajax_cancel_like', as: 'image_cancel_like'
  post 'images/:id/cancel_dislike' => 'images#ajax_cancel_dislike', as: 'image_cancel_dislike'
  post 'images/load_more' => 'images#ajax_load_more', as: 'image_load_more'

  resources 'yogy', param: :title
  get 'yogy/:title/season/:season' => 'yogy#show', as: 'yogy_season'
  get 'yogy/:title/year/:year' => 'yogy#show', as: 'yogy_year'
  get 'yogy/:title/season/:season/year/:year' => 'yogy#show', as: 'yogy_season_year'
  post 'yogy/load_more' => 'yogy#ajax_load_more', as: 'yogy_load_more'


  get 'index_v2', to: 'yogy#index_v2'
  get 'index_v3', to: 'yogy#index_v3'
  get 'index_v4', to: 'yogy#index_v4'
  get 'about', to: 'yogy#about'

  get '/dn/:image_id/:type' =>'dn#show', as: 'dn'

  get 'settings', to: 'settings#index'
  post 'settings', to: 'settings#ajax_update_profile'
  delete 'settings', to: 'settings#ajax_delete_me'

  root to: 'yogy#index_v4'
end
