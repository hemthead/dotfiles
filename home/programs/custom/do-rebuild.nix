{writeShellScriptBin}:
writeShellScriptBin "do-rebuild" ''
  # original source: https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5 (credit to @0atman)
  # a rebuild script that commits on a successful build

  set -e

  # edit before hand
  # $EDITOR ...

  # cd to dotfiles
  pushd ~/dotfiles/

  # early return if no diff (credit to @singiamtel)
  if git diff --quiet; then
    echo "No changes detected, exiting.";
    popd
    exit 0
  fi

  # add nix fmt here potentially (probs should)

  # show changes
  git diff -U0

  echo "NixOS Rebuilding..."

  # rebuild, output simplified errors, log tracebacks
  sudo nixos-rebuild switch --flake ./ &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

  # get generation metadata
  current=$(nixos-rebuild list-generations | grep current)

  # commit changes with generation metadata
  git commit -am "$current";

  # go back to wherever
  popd
''
