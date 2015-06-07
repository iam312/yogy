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

  resources 'yogy' do
  end

  root to: 'yogy#index'
end
