function less
  if test (count $argv) -eq 0
    # echo "No argument given. List the current directory."
    set_color green
    echo '. is a directory'
    set_color normal
    command ls .
  else if test -d "$argv[-1]"
    # echo "Last argument is a directory. List it."
    set_color green
    echo "$LAST_ARG is a directory"
    set_color normal
    command ls "$argv[-1]"
  else
    # echo "Fallback to command less."
    command less -giJ --underline-special --SILENT "$argv"
  end
end
