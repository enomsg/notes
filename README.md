### Agda in Docker

[~/bin/env-agda](env-agda)

```bash
#!/usr/bin/env bash

E=~/.env-agda
rm -rf "$E"
if [ -e ~/.git ]; then git clone ~ "$E" ; else mkdir -p "$E"; fi

cat > ~/.env-agda/.Dockerfile << EOF_DOCKERFILE
from debian:buster

# Deliberately use separate run commands
run apt-get update

run apt-get install -y agda-bin
run apt-get install -y agda-stdlib

run apt-get install -y emacs
run apt-get install -y elpa-agda2-mode
run apt-get install -y elpa-auto-complete
run apt-get install -y elpa-rainbow-delimiters
run apt-get install -y elpa-evil

run apt-get install -y screen

run apt-get install -y locales
run echo en_US.UTF-8 UTF-8 > /etc/locale.gen
run dpkg-reconfigure locales --frontend=noninteractive

run useradd -s /bin/bash user
env SHELL /bin/bash
env LANG en_US.UTF-8
env LC_CTYPE en_US.UTF8

user user
cmd screen
EOF_DOCKERFILE

docker build -t env-agda -f ~/.env-agda/.Dockerfile ~/.env-agda && \
docker run --network none \
           -w /home/user/pwd \
           -e TERM="$TERM" \
           -v "$HOME/.env-agda":/home/user \
           -v "$PWD":/home/user/pwd \
           -it env-agda "$@"
```

```
$ chmod +x ~/bin/env-agda
$ env-agda
```

### Agda in NixOS shell

[agda.nix](agda.nix)

```nix
{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

let
  ghc   = pkgs.haskellPackages.ghcWithPackages
            (p: with p; [ ieee754 ]);
  emacs = pkgs.emacsWithPackages
            (p: with p; [ evil agda2-mode auto-complete rainbow-delimiters ]);
  der   = agda.mkDerivation(self: {
    name         = "AgdaEnv";
    buildDepends = [ pkgs.AgdaStdlib ghc emacs ];
  });
in der.env
```

```
$ nix-shell agda.nix
```