#!/bin/bash

# Ensure gh CLI is installed
if ! command -v gh &>/dev/null; then
    echo "Error: GitHub CLI (gh) is not installed."
    exit 1
fi

# Load GitHub configuration from .github.env
GITHUB_ENV_FILE=".github.env"

if [ ! -f "$GITHUB_ENV_FILE" ]; then
    echo "Error: Could not find .github.env file at $GITHUB_ENV_FILE"
    exit 1
fi

# Load variables from .github.env
export $(grep -v '^#' "$GITHUB_ENV_FILE" | xargs)

# Check required variables
if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
    echo "Error: OWNER and REPO must be set in .github.env"
    exit 1
fi

# Check if .env file exists
ENV_FILE=".env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Could not find .env file at $ENV_FILE"
    exit 1
fi

# Authenticate with GitHub if not already authenticated
if ! gh auth status &>/dev/null; then
    echo "You need to authenticate with GitHub CLI."
    gh auth login
fi

# Read .env file and process secrets
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    if [[ -z "$line" ]] || [[ "$line" =~ ^# ]]; then
        continue
    fi

    # Extract key and value
    if [[ "$line" =~ ^([^=]+)=(.*)$ ]]; then
        SECRET_NAME="${BASH_REMATCH[1]}"
        SECRET_VALUE="${BASH_REMATCH[2]}"

        # Remove possible surrounding quotes from the value
        SECRET_VALUE=$(echo "$SECRET_VALUE" | sed -e 's/^"//' -e 's/"$//')

        echo "Processing secret: $SECRET_NAME"

        # Set the secret using gh secret set
        echo -n "$SECRET_VALUE" | gh secret set "$SECRET_NAME" --repo "$OWNER/$REPO" -b -

        if [ $? -eq 0 ]; then
            echo "Secret '$SECRET_NAME' created/updated successfully."
        else
            echo "Error: Failed to create/update secret '$SECRET_NAME'."
        fi
    fi
done <"$ENV_FILE"
