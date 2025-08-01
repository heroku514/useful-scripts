#!/bin/bash

# Define an associative array with repo URLs and folder names
declare -A repos=(
  ["goflyer-server"]="https://goflyer@bitbucket.org/goflyer/goflyer-server.git"
  ["goflyer-admin-v2"]="https://goflyer@bitbucket.org/goflyer/goflyer-admin-v2.git"
  ["goflyer-scripts-v8"]="https://goflyer@bitbucket.org/goflyer/goflyer-scripts-v8.git"
  ["goflyer-figma-flyer-automation-plugin"]="https://goflyer@bitbucket.org/goflyer/goflyer-figma-flyer-automation-plugin.git"
  ["goflyer-reactjsapp"]="https://goflyer@bitbucket.org/goflyer/goflyer-reactjsapp.git"
  ["goflyer-ui-testing"]="https://goflyer@bitbucket.org/goflyer/goflyer-ui-testing.git"
  ["goflyer-nations-oceans-app"]="https://goflyer@bitbucket.org/goflyer/goflyer-nations-oceans-app.git"
)

for folder in "${!repos[@]}"; do
  if [ -d "$folder" ]; then
    echo "Directory '$folder' already exists. Skipping clone."
  else
    echo "Cloning ${repos[$folder]} into '$folder'..."
    git clone "${repos[$folder]}"
  fi
done
