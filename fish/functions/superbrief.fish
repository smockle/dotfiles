function __superbrief
  command cd $argv
end

function superbrief
  alias cd=__superbrief
  echo "Low verbosity"
end
