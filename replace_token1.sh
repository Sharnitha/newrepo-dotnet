#/bin/bash
set -e
 
# Input Parameters
BaseUrl="$1"
ApiKey="$2"
 
# Validate Inputs
if [[ -z "$BaseUrl" || -z "$ApiKey" ]]; then
  echo "Usage: $0 <BaseUrl> <ApiKey> "
  exit 1
fi
 
# Escape Special Characters in BaseUrl
escaped_BASE_URL=$(printf '%s' "$BaseUrl" | sed 's/[&/\$\;]/\\&/g')
 
# Replace {__BaseUrl__} in appsettings.json
sed -i "s|{__BaseUrl__}|${escaped_BASE_URL}|g" "$AppSettingsFile"
 
# Escape Special Characters in ApiKey
escaped_API_KEY=$(printf '%s' "$ApiKey" | sed -e 's/[&/\]/\\&/g' -e 's/\$/\\$/g')
 
# Replace {__ApiKey__} in appsettings.json
sed -i "s|{__ApiKey__}|${escaped_API_KEY}|g" "$AppSettingsFile"
 
# Debug Output
echo "Updated appsettingwith BaseUrl and ApiKey"
