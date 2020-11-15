#!/usr/bin/env bash
set -euo pipefail

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------

LOCAL_DIR="/usr/local"
BATS_EXIST=$( (command -v bats &> /dev/null) && echo "1" || echo "0" )

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

install_bats() {
  if [[ $BATS_EXIST == "0" ]]; then
    git clone https://github.com/bats-core/bats-core.git
    install -d -m 755 "${LOCAL_DIR}"/{bin,libexec/bats-core,lib/bats-core,share/man/man{1,7}}
    install -m 755 "bats-core/bin/bats" "${LOCAL_DIR}/bin"
    install -m 755 "bats-core/libexec/bats-core"/* "${LOCAL_DIR}/libexec/bats-core"
    install -m 755 "bats-core/lib/bats-core"/* "${LOCAL_DIR}/lib/bats-core"
    install -m 644 "bats-core/man/bats.1" "${LOCAL_DIR}/share/man/man1"
    install -m 644 "bats-core/man/bats.7" "${LOCAL_DIR}/share/man/man7"
    rm -rf bats-core
    echo "bats Installed!!"
  else
    echo "Bats already installed."
  fi
}

remove_bats() {
  if [[ $BATS_EXIST == "1" ]]; then
    rm -f \
       "${LOCAL_DIR}/bin/bats" \
       "${LOCAL_DIR}/share/man/man1/bats.1" \
       "${LOCAL_DIR}/share/man/man7/bats.7"
    rm -rf \
       "${LOCAL_DIR}/libexec/bats-core" \
       "${LOCAL_DIR}/lib/bats-core"

    echo "bats removed!!"
  else
    echo "Bats not found."
  fi
}

#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------
if [[ -z ${1:-} || ${1:-} == 'install' ]]; then
  install_bats
elif [[ $1 == "remove" ]]; then
  remove_bats
else
  printf '%s\n' \
	 'usage: ' \
	 "  ${0} install " \
	 "  ${0} remove" >&2
  exit 1
fi
