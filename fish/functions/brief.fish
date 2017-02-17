function __brief
  command cd $argv; and ls
end

function brief
  alias cd=__brief
  echo "Medium verbosity"
end
