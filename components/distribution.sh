#!/bin/bash

# Export the distribution as an environment variable (if not already set)
if [ -z "$DISTRIBUTION" ]; then
  DISTRO=$(lsb_release -si 2>/dev/null || cat /etc/os-release | grep '^ID=' | cut -d'=' -f2- | tr -d '"')
	export DISTRIBUTION=${DISTRO^}
fi
