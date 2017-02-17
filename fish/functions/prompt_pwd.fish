function prompt_pwd
  set -l path (pwd | sed "s|$HOME|~|" | tr '/' '\n')
  if test (count $path) -lt 4
     echo (pwd | sed "s|$HOME|~|")
  else
    set output ''
    if string match -i -r "$HOME" (pwd) >/dev/null
      set output '~/.../'
    else
      set output '.../'
    end
    set output "$output"(pwd | tr '/' ' ' | rev | cut -f1,2 -d' ' | rev | tr ' ' '/')
    echo $output
    set -e output
  end
  set -e path
end
