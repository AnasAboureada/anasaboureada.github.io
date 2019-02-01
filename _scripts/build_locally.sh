#!/bin/bash

# Enable error reporting to the console.
set -e


# make sure old files are deleted
gulp clean

# Build the site.
gulp

# Make sure that all assets are copied to _site/assets
cp -Rf ./assets/ ./_site/assets
./_scripts/run-tests.sh

cd ../blog_build
rm -rf *

# Copy generated HTML site from source branch in original repo.
# Now the master branch will contain only the contents of the _site directory.
cp -R ../blog/_site/* .

# Make sure we have the updated .travis.yml file so tests won't run on master.
cp ../blog/.travis.yml .

# Commit and push generated content to master branch.
git status
git add -A .
git status
git commit -a -m "Local build"
git push --quiet origin master > /dev/null 2>&1
