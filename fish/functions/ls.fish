function ls
  if test -f $argv[-1]
    # echo "Last argument is a file. List the directory that contains it."
    set_color green
    echo (dirname "$argv[-1]")
    set_color normal
    command ls -G (dirname "$argv[-1]")
  else
    # echo "Fallback to command ls."
    command ls -G $argv
  end
end
