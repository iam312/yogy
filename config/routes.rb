Rails.application.routes.draw do
  resources 'images' do
  end

  resources 'yogy' do
  end

  root to: 'images#new'
end
