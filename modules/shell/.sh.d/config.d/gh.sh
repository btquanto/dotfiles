function gh-list-mutations() {
  gh api graphql -f query='
{
  __schema {
    mutationType {
      fields {
        name
        description
      }
    }
  }
}
' # | jq -r '.data.__schema.mutationType.fields[] | "\(.name): \(.description)\n"'
}

function gh-get-schema() {

  SCHEMA="$1"

  if [[ -z "$SCHEMA" ]]; then
      echo "Usage: gh-get-schema <SchemaName>"
      return 1
  fi
    
  gh api graphql -f query="
  {
    __type(name: \"$SCHEMA\") {
      name
      fields {
        name
        type {
          name
          kind
        }
      }
    }
  }
  " # | jq -r ".data.__type.fields.[].name"
}

function gh-get-rate-limit() {
  gh api graphql -f query='
    {
      viewer {
        login
      }
      rateLimit {
        limit
        remaining
        used
        resetAt
      }
    }
  '
}