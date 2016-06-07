source 'https://rubygems.org'

#gem 'rails', '4.1.4'
gem 'rails', '~>4.1.7'
gem 'puma'
gem 'andand'
gem 'figaro'

# for memcached
gem 'kgio'
gem 'dalli'

# delayed_job
gem 'delayed_job_active_record'
gem 'daemons'

# 이미지 처리
gem 'carrierwave'
gem 'mini_magick'
gem 'aws-sdk', '~> 1.36.1'
gem 'fog'
gem 'exiftool_vendored'

# 회원 인증
gem 'devise'
gem 'omniauth-facebook'

# front-end
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'bootstrap-sass'
gem 'sass-rails'
gem 'uglifier'
gem 'http_accept_language'
gem 'browser-timezone-rails'

group :development do
  gem 'guard-ctags-bundler'
end

group :development, :test do
  gem 'mysql2'
  gem 'byebug'
  gem 'pry-byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails', '~> 3.0'
end

group :production do
  gem 'pg'
end

ruby '2.3.1'
