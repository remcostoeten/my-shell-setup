# Function to generate JWT secret
jwt_secret_generator() {
  # Generate a 64-character random string using openssl
  SECRET=$(openssl rand -base64 48 | tr -dc 'a-zA-Z0-9' | head -c 64)

  # Create the full JWT_SECRET string
  JWT_STRING="JWT_SECRET=$SECRET"

  # Copy to clipboard based on OS
  case "$(uname -s)" in
  Darwin*) # macOS
    echo $JWT_STRING | pbcopy
    ;;
  Linux*) # Linux
    echo $JWT_STRING | xclip -selection clipboard 2>/dev/null ||
      echo $JWT_STRING | xsel -ib 2>/dev/null ||
      echo $JWT_STRING | wl-copy 2>/dev/null
    ;;
  esac

  # Print confirmation and the secret
  echo "✓ JWT_SECRET has been copied to clipboard!"
  echo $JWT_STRING
}

# Function to generate normal secret
secret_generator() {
  # Generate a 32-character random string using openssl
  SECRET=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)

  # Create the full SECRET string
  SECRET_STRING="SECRET=$SECRET"

  # Copy to clipboard based on OS
  case "$(uname -s)" in
  Darwin*) # macOS
    echo $SECRET_STRING | pbcopy
    ;;
  Linux*) # Linux
    echo $SECRET_STRING | xclip -selection clipboard 2>/dev/null ||
      echo $SECRET_STRING | xsel -ib 2>/dev/null ||
      echo $SECRET_STRING | wl-copy 2>/dev/null
    ;;
  esac

  # Print confirmation and the secret
  echo "✓ SECRET has been copied to clipboard!"
  echo $SECRET_STRING
}

# Create the aliases
alias jwt='jwt_secret_generator'
alias secret='secret_generator'
