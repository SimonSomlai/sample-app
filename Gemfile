source 'https://rubygems.org'

ruby '2.2.2', :engine => 'jruby', :engine_version => '9.0.0.0'

gem 'rails', '4.2.5'
gem 'activerecord-jdbcsqlite3-adapter'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyrhino'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem "puma"
gem 'bcrypt', '~> 3.1', '>= 3.1.11'
gem 'pry', '~> 0.10.3'
gem 'faker', '~> 1.6', '>= 1.6.3'
gem 'will_paginate', '~> 3.1'
gem 'bootstrap-will_paginate', '~> 0.0.10'
gem 'carrierwave', '~> 0.11.2'
gem 'fog', '~> 1.38'
gem 'mini_magick', '~> 4.5', '>= 4.5.1'


group :test do
  gem 'minitest-reporters'
  gem 'minitest'
end

group :production do
  gem "rails_12factor"
  gem 'activerecord-jdbcpostgresql-adapter'
end

group :development do
  gem "better_errors"
  gem "meta_request"
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
