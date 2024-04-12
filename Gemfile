source 'https://gems.ruby-china.com/'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'
gem 'rexml', '~> 3.2', '>= 3.2.5'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'
gem 'mysql2', '~> 0.5'
gem 'clickhouse-activerecord'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'listen', '~> 3.3'
gem 'net-ssh', '>= 6.0.2'
gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'
# Object saving
gem 'qiniu', '>= 6.9.1'
gem 'retries'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'devise'
gem 'rolify'
gem 'cancancan'

gem 'kaminari'

gem 'sidekiq', '~> 5.2.8'
gem 'sidekiq-scheduler'
gem 'sidekiq-status'

# 用户token生成
gem 'jwt'
# API docs
gem 'swagger-blocks'

# 跨域
gem 'rack-cors', :require => 'rack/cors'

# 二维码
gem "rqrcode", "~> 2.0"
# 生成xlsx文件
gem 'write_xlsx', '~> 1.0'
gem 'rubyXL'
gem "roo", "~> 2.9.0"
# html转图，用于生成预览图+二维码的图
gem 'mini_magick', '~> 4.11'
# 图片压缩转换成webp
gem 'tinify'
# 变pdf 等的供应商需要
gem 'prawn', '~> 2.4'
# 翻译enum
gem 'translate_enum'
# 解压缩gem
gem 'rubyzip'

gem 'nokogiri'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'pry-byebug'
  gem 'sshkit-sudo'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'annotate'

  gem 'capistrano', '~> 3.16.0'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano3-puma'
  gem 'capistrano-bundler'
  gem 'capistrano-sidekiq'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
