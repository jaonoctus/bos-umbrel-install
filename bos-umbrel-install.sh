#!/bin/bash
#
# This script will install BOS on Umbrel
# version:  0.1.0
# author:   jaonoctus <jaonoctus@protonmail.com>

set -eo pipefail

main() {
  local umbrel_env_path="$(pwd)/.env"
  local umbrel_start_script_path="$(pwd)/scripts/start"
  local cert_path="$(pwd)/app-data/lightning/data/lnd/tls.cert"
  local macaroon_path="$(pwd)/app-data/lightning/data/lnd/data/chain/bitcoin/mainnet/admin.macaroon"
  local bos_path="$(pwd)/app-data/docker-bos"
  local bos_node_path="${bos_path}/umbrel"
  local bos_script_path="$(pwd)/bin/bos"

  check_is_root() {
    if [[ "${EUID}" -ne 0 ]]; then
      printf "ERROR: you must run this script as root.\n\n$ sudo bash bos-umbrel-install.sh\n"
      exit 1
    fi
  }

  check_is_under_umbrel() {
    # assert that those files exists
    if [[ ! -f "${umbrel_env_path}" || ! -f "${umbrel_start_script_path}" ]]; then
      printf "ERROR: run this script inside UMBREL folder only.\n"
      exit 1
    fi
    if [[ ! -f "${cert_path}" || ! -f "${macarron_path}" ]]; then
      printf "ERROR: make sure to start and configure LND first."
      exit 1
    fi
  }

  install_bos_bin() {
    # create bos file
    printf "#!/bin/bash\n\ndocker run -it --rm --network=\"umbrel_main_network\" -v ${bos_path}:/home/node/.bos alexbosworth/balanceofsatoshis:latest \"\$@\"\n" | sudo tee "${bos_script_path}"
    # set file as executable
    sudo chmod +x "${bos_script_path}"
    # create bos folder
    sudo mkdir -p "${bos_node_path}"
  }

  write_bos_configs() {
    # load env from umbrel
    . ".env"
    # write bos config
    printf "{\n\t\"default_saved_node\": \"umbrel\"\n}\n" | sudo tee "${bos_path}/config.json"
    # write node credentials
    local cert=$(base64 "${cert_path}" | tr -d '\n')
    local macaroon=$(base64 "${macaroon_path}" | tr -d '\n')
    printf "{\n\t\"cert\": \"${cert}\",\n\t\"macaroon\": \"${macaroon}\",\n\t\"socket\": \"${LND_IP}:10009\"\n}\n" | sudo tee "${bos_node_path}/credentials.json"
  }

  check_is_root
  check_is_under_umbrel
  install_bos_bin
  write_bos_configs
}

main
