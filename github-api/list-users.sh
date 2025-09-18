#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username #we need to enter the github user name
TOKEN=$token #go to settings -- developer settings and generate a new token with mentioned required permissions

# User and Repository information
REPO_OWNER=$1 # $1 means it is the first org name
REPO_NAME=$2 # it indicates the repo name we are looking for

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')" #this jq-r used to print only the name or the one which is mentioned to login field.

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then # -z means if the string is empty in the collaborators print no one has the access
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"  #it will print who has the access
        echo "$collaborators"
    fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
#function ends
