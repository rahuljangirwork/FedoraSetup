#!/usr/bin/env bash
# ... (Header and helper functions remain mostly the same) ...

# --- Default Settings ---
DEFAULT_TIMEZONE="Asia/Kolkata"
DEFAULT_KEYMAP="us"

# ... (Other functions like 'logo', 'filesystem', etc., are not needed for this minimal installation) ...

# --- Main Script ---
background_checks
clear
logo 

# --- User Information ---
userinfo

# --- Set Default Values ---
set_option TIMEZONE "${DEFAULT_TIMEZONE}"
set_option KEYMAP "${DEFAULT_KEYMAP}"

# ... (You can add more prompts for customization here if needed) ...
