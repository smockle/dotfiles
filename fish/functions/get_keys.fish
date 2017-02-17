function get_keys
  set -l keys (keybase list-tracking)
  for key in $keys
    curl "https://keybase.io/$key/key.asc" | gpg --import
  end
end
