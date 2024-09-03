# Countdown Timer Script

This script is designed to create a countdown timer that can be set for a specific amount of time. It can be used to count down from a specified number of seconds, minutes, or hours. When the countdown reaches zero, it plays an alarm sound and displays a notification message.

## Usage

To use the countdown timer, simply call the `countdown_timer` function followed by the desired time duration. The time duration can be specified in seconds (s), minutes (m), or hours (h). For example:

* `countdown_timer 10s` for a 10-second countdown
* `countdown_timer 10m` for a 10-minute countdown
* `countdown_timer 1h` for a 1-hour countdown
* `countdown_timer 1m 33s` for a countdown of 1 minute and 33 seconds

## Features

* Converts input time units (seconds, minutes, hours) to total seconds for the countdown
* Displays the time remaining in seconds during the countdown
* Plays an alarm sound when the countdown reaches zero
* Displays a notification message when the countdown reaches zero

## Customization

The script can be customized by modifying the `ALARMFILE` variable to point to a different alarm sound file. Additionally, the notification message can be changed by modifying the text in the `zenity` command.

## Installation

To use this script, save it to a file (e.g., `countdown_timer.bash`), make the file executable with `chmod +x countdown_timer.bash`, and then add it to your system's PATH. You can then call the script from anywhere in your terminal.
