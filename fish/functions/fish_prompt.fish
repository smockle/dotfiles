function parse_git_branch -d "Output git's current branch name"
  begin
    git symbolic-ref --quiet --short HEAD; or \
    git describe --all --exact-match HEAD; or \
    git rev-parse --short HEAD; or '(unknown)'
  end ^/dev/null | sed -e 's|^refs/heads/||'
end

function git_uncommitted_changes
  if not command git diff --quiet --ignore-submodules --cached
    echo '+'
  end
end

function git_unstaged_changes
  if not command git diff-files --quiet --ignore-submodules --
    echo '!'
  end
end

function git_untracked_files
  set untracked_files (command git ls-files --others --exclude-standard)
  if test (count $untracked_files) -gt 0
    echo '?'
  end
end

function git_stashed_files
  if command git rev-parse --verify refs/stash ^/dev/null
    echo '$'
  end
end

function git_prompt
  # Check if is on a Git repository
  if git rev-parse ^ /dev/null
    set git_branch_name (set_color magenta)(parse_git_branch)(set_color normal)

    # Check if there is an upstream configured
    set git_flags ''
    command git rev-parse --abbrev-ref '@{upstream}' >/dev/null ^&1; and set -l has_upstream
    if set -q has_upstream
      set git_flags (git_uncommitted_changes) (git_unstaged_changes) (git_untracked_files) (git_stashed_files)
      set git_flags (echo $git_flags | tr -d ' ')
      if test (string length $git_flags) -gt 0
        set git_flags ' '(set_color blue)"[$git_flags]"(set_color normal)
      end
    end

    # Format Git prompt output
    echo "on $git_branch_name$git_flags"
  end
end

function fish_prompt
  echo ''
  echo (set_color yellow)$USER(set_color normal) (set_color brblack)in(set_color normal) (set_color green)(prompt_pwd)(set_color normal) (git_prompt)
  echo '$ '
end
