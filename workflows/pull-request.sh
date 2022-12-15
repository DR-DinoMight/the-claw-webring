#!/bin/sh
git fetch origin main
# Run the `git diff` command to compare the current branch with the `origin/main` branch
URLS=$(git diff origin/main..HEAD --unified=0 -- ./data/members.json  | grep '^+' | grep -o '\"url\":\s\".*\"' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | sort -u)

# Use a for loop to iterate over the URLs in the $URLS variable
for url in $URLS; do
  # Use curl and grep to search for the <the-claw-webring-widget> tag in the URL
  curl -s $url | grep -qo "<the-claw-webring-widget>"

  # Check the exit status of the previous command
  if [ $? -eq 0 ]; then
    # Print a message indicating that the tag was found in the URL

    if [[ "${url: -1}" != *'/'* ]]; then
      echo "::warning file=./data/members.json::$url: ❌ (Dosen't have a trailing / at the end)"
    else
          echo "::debug::$url: ✅"
    fi
  else
    # Print a message indicating that the tag was not found in the URL
    echo "::warning file=./data/members.json::$url: ❌ (Dosen't have the webring tag)"
  fi
done

echo "Finished searching"
exit 0
