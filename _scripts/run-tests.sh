#!/usr/bin/env bash
set -e
# bundle exec scss-lint _assets/styles/*/*/*.scss
bundle exec mdl . -c .mdlrc --git-recurse
gulp clean
gulp build:local

# Make sure that all assets are copied to _site/assets
cp -Rf ./assets/ ./_site/assets

# gulp accessibility-test
bundle exec rake test -f Rakefile
