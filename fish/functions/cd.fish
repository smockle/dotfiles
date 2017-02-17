function cd
  if test (count $argv) -eq 0
    # echo "No argument given. Fallback to command cd."
    builtin cd $argv
  else if test -f "$argv[-1]"
    # echo "Last argument is a file. Change to the directory that contains it."
    set -l opts (echo "$argv" | tr ' ' '\n' | tail -r | tail -n +2 | tail -r | tr '\n' ' ')
    builtin cd $opts (dirname "$argv[-1]")
    set -e opts
  else
    # echo "Fallback to command cd."
    builtin cd $argv
  end
end
