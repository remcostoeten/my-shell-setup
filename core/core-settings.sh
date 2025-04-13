#!/bin/bash

# -------------------------------------------------------------------------
# MacOS Performance Optimization Script
# -------------------------------------------------------------------------
# This script contains settings to make macOS feel snappier and less laggy
# Run with: bash core-settings.sh
# -------------------------------------------------------------------------

echo "Applying performance optimizations to macOS..."

# -------------------------------------------------------------------------
# DOCK OPTIMIZATIONS
# -------------------------------------------------------------------------
echo "Optimizing Dock..."
# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don't animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# -------------------------------------------------------------------------
# FINDER OPTIMIZATIONS
# -------------------------------------------------------------------------
echo "Optimizing Finder..."
# Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Don't show recent tags
defaults write com.apple.finder ShowRecentTags -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# -------------------------------------------------------------------------
# SYSTEM UI OPTIMIZATIONS
# -------------------------------------------------------------------------
echo "Optimizing System UI..."
# Disable smooth scrolling
# (Uncomment if you prefer less smooth but more responsive scrolling)
# defaults write -g NSScrollAnimationEnabled -bool false

# Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Speed up sheet animations
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable transparency in the menu bar and elsewhere
defaults write com.apple.universalaccess reduceTransparency -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# -------------------------------------------------------------------------
# HARDWARE OPTIMIZATIONS
# -------------------------------------------------------------------------
echo "Optimizing hardware settings..."
# Disable local Time Machine backups (can improve performance)
sudo tmutil disablelocal

# Disable sudden motion sensor (useful for SSDs)
sudo pmset -a sms 0

# -------------------------------------------------------------------------
# SAFARI OPTIMIZATIONS
# -------------------------------------------------------------------------
echo "Optimizing Safari..."
# Disable Safari's thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Make Safari's search banners default to contains instead of starts with
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# -------------------------------------------------------------------------
# SYSTEM ANIMATIONS OPTIMIZATIONS
# -------------------------------------------------------------------------
echo "Optimizing system animations..."
# Disable animations when opening and closing windows
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Disable animations when opening Terminal.app
defaults write com.apple.Terminal FocusFollowsMouse -string YES

# -------------------------------------------------------------------------
# CLEANUP AND RESTART
# -------------------------------------------------------------------------
echo "Restarting affected applications..."
# Kill affected applications
for app in "Dock" "Finder" "Safari" "SystemUIServer"; do
  killall "${app}" &>/dev/null
done

echo "All optimizations applied! Some settings might require a restart to take full effect."
echo "Consider restarting your Mac for the best performance."
