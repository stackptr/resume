build:
  nix build .#resume
  cp -L result resume.pdf
