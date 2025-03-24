#!/usr/bin/env python3
from pynput import mouse, keyboard
import time
import threading
import sys

# Flag to track if 'b' is pressed
# Not sure which keys all work, but `B` will  only fire when capital B is pressed for example. `ctrl` does not work. Should prolly read docs.

b_pressed = False
# Flag to control the script
running = True

def on_press(key):
    global b_pressed
    try:
        if key.char == 'B':
            b_pressed = True
    except AttributeError:
        pass

def on_release(key):
    global b_pressed
    try:
        if key.char == 'b':
            b_pressed = False
        elif key == keyboard.Key.esc:
            # Stop the script when ESC is pressed
            global running
            running = False
            return False
    except AttributeError:
        pass

def auto_click():
    mouse_controller = mouse.Controller()
    while running:
        if b_pressed:
            mouse_controller.click(mouse.Button.left)
            time.sleep(0.1)  # 10 clicks per second max

print("Hold 'B' to auto-click. Press ESC to exit.")

# Start keyboard listener
keyboard_listener = keyboard.Listener(on_press=on_press, on_release=on_release)
keyboard_listener.start()

# Start clicking thread
click_thread = threading.Thread(target=auto_click)
click_thread.start()

# Wait for the threads to complete
keyboard_listener.join()
click_thread.join()
