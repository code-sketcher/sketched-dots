#!/bin/bash

# Wait for kwallet
kwallet-query -l kdewallet >/dev/null

ssh-add -q $HOME/.ssh/id_rsa </dev/null
