function __verbose
  command cd $argv; and ls -a
end

function verbose
  alias cd=__verbose
  echo "Maximum verbosity"
end
