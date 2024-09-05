# Screen Scaling Function for Pop!_OS

This bash function and alias allow you to quickly adjust the screen scaling on Pop!_OS from the command line.

## What it does

- Provides a simple command to change text scaling factor in GNOME
- Allows setting any percentage for scaling
- Works through a custom bash function and alias

## Usage

After installation, use the following command:

```
screen <percentage>
@@@

For example:
@@@
screen 125
@@@
This sets the screen scaling to 125%.

## How it works

The function uses `gsettings` to modify the GNOME desktop text scaling factor. This affects the size of text and some UI elements across the system.

## Note

This primarily adjusts text scaling and may not exactly match the "Scale" setting in GNOME display settings. For more precise display scaling, additional configuration may be needed.

## Installation

Add the function and alias to your `~/.bashrc` file. See the main documentation for detailed installation steps.
