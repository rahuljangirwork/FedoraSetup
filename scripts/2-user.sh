#!/bin/bash 
# ... (Header remains the same) ...

source $HOME/FedoraRahul/configs/setup.conf

# ... (zsh and powerlevel10k installation remains similar) ...

# --- Package Installation (Use dnf and potentially copr) ---
dnf -y install $(cat ~/FedoraRahul/pkg-files/${DESKTOP_ENV}.txt) 

# --- Consider copr for additional packages ---
# dnf copr enable <repository> 
# dnf install <package>

# ... (Theming and other customizations remain similar) ...
