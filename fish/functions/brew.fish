function __difference
  echo $argv | tr ' ' '\n' | sort | uniq -u
end

function __intersection
  echo $argv | tr ' ' '\n' | sort | uniq -d | uniq
end

function brew
  switch $argv[1]
    # Remove installed depedencies that are no longer used.
    case unbrew
      set -l uninstall ''
      set -l preserve 'bash bash-completion curl fasd fish flow git highlight hub mongodb photoshop-jpegxr photoshop-webp watchman wget'
      set -l packages (command brew list | tr '\n' ' ' | tr ' ' '\n')

      # Don't uninstall packages in the preserve list
      set -l packages (__intersection $packages (__difference $preserve $packages))
      for package in $packages

        # Get packages which depend on the current package
        set -l parent (command brew uses --installed --recursive $package)

        # Don't uninstall packages preserved pacakges depend on
        set -l unpreserved (__intersection $parent (__difference $preserve $parent))

        # Uninstall packages nothing depends on
        if test (count $parent) -eq 0
          command brew uninstall $package

        # Uninstall packages no preserved packages depend on
        else if test (count $parent) -eq (count $unpreserved)
          command brew uninstall $package
        end
      end
    case '*'
      command brew $argv
  end
  return $status
end
