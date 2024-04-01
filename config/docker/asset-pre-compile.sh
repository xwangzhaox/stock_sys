#! /bin/sh

# bundle exec rails webpacker:install
bundle exec rails webpacker:compile

# Precompile assets for production
bundle exec rake assets:precompile

echo "Assets Pre-compiled!"
