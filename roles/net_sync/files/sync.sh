#!/bin/bash
set -e

if ! ssh -p 2222 -q -o BatchMode=yes $(hostname)@{{ net_sync_hostname }}"$@" true
then
  echo "RECHNER NOCH NICHT REGISTRIERT. PASSWORT NOTWENDIG" 
  if [ ! -f "$HOME/.ssh/id_rsa" ]
  then
    ssh-keygen -q -f "$HOME/.ssh/id_rsa" -N ""
  fi
  ssh-copy-id -p 2222 $(hostname)@{{ net_sync_hostname }}
  echo "RECHNER ERFOLGREICH REGISTRIERT"
fi
rsync -e 'ssh -p 2222' --exclude-from ~/.backup_excludes -avzP /home/pi/ $(hostname)@{{ net_sync_hostname }}:~/

unison home_sync -root $1-root $2
