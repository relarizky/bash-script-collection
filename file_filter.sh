#!/usr/bin/env bash

# i made this script for helping me to do LSP (Lembaga Sertifikasi Profesi) task
# this script was made to be used with cronjob to be executed periodically
# this script will delete all the files with unwanted extension (based on LSP task)

set -o errexit
set -o nounset
set -o pipefail

# change these constants based on your environment
readonly HOME="/home/relzz/"
readonly SHARES="TKJ MM RPL"

check_privilege(){
  local uid=$(id | grep --perl-regexp --only-match 'uid=[\d]*' | cut --fields 2 --delimiter "=")

  echo ${uid}
}

current_time(){
  local current_time="$(date | cut --fields 5 --delimiter " ")"

  echo ${current_time}
}

file_filter(){
  local name="${1}"  # file name
  local exts="$(python3 -c "print('${name}'.split('.')[-1].lower())")"  # file extension

  if [ ${exts} != "odt" ] && [ ${exts} != "doc" ] && [ ${exts} != "docx" ]; then
    rm -rf ${name}
    echo "[$(current_time)] Successfully removed ${name}"
  fi
}

main(){
  local share="${HOME}${1}"
  local content=()  # array

  for file in $(find ${share} -maxdepth 1 -type f); do
    file_filter "${file}"
  done
}

if [ $(check_privilege) -ne 0 ]; then
  echo "[-] You are not root."
  exit 1
fi

for share in ${SHARES}; do
  main "${share}"
done
