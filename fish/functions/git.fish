function git
  if test (count $argv) -eq 0
    hub $argv
    return $status
  end
  switch $argv[1]
  # Create a new branch with the same name if one does not exist,
  # safer than `git config --global push.default current`.
  case push
    set -l BRANCH_NAME (git rev-parse --abbrev-ref HEAD)
    set -l trailing_options (echo "$argv" | tr ' ' '\n' | tail -n +2 | tr '\n' ' ')
    if test (count git config "branch.$BRANCH_NAME.merge") -gt 0
      and test (count trailing_options | tr ' ' '\n') -gt 0
      hub push --set-upstream origin "$BRANCH_NAME"
    else if test (count git config "branch.$BRANCH_NAME.merge") -gt 0
      hub push --set-upstream $trailing_options
    else
      hub $argv
    end
    set -e trailing_options
  # Check other host if no repo exists at default host.
  case clone
    hub $argv ^/dev/null
    if test $status -ne 0
      set -lx GITHUB_HOST (git config --global hub.host)
      hub $argv
    end
  # Remove all local branches that have been merged into master.
  # http://stackoverflow.com/a/17029936/1923134
  # case unbranch
  #   git fetch --prune; and git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
  case diff
    set -l trailing_options (echo "$argv" | tr ' ' '\n' | tail -n +2 | tr '\n' ' ')
    hub diff --color $trailing_options | diff-so-fancy
    set -e trailing_options
  case '*'
    hub $argv
  end
  return $status
end
