set url (glab mr list --source-branch (__git.current_branch) -F json | jq -r '.[0].web_url')
  if test -n "$url"
      open "$url"
  end
