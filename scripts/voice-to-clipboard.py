import speech_recognition as sr
import pyperclip
import sys
import threading
import time

def recognize_speech(language='en-US', sensitivity=1.0):
    recognizer = sr.Recognizer()
    
    try:
        with sr.Microphone() as source:
            print("Adjusting for ambient noise. Please wait...")
            recognizer.adjust_for_ambient_noise(source, duration=2)
            print(f"Initial energy threshold: {recognizer.energy_threshold}")
            
            # Increase sensitivity by lowering the energy threshold
            recognizer.energy_threshold *= sensitivity
            print(f"Adjusted energy threshold: {recognizer.energy_threshold}")
            
            print("Listening... Say something! (5s silence or Enter to process and quit)")
            
            audio_data = []
            is_listening = True
            last_audio_time = time.time()

            def listen_in_background():
                nonlocal last_audio_time, is_listening
                while is_listening:
                    try:
                        audio = recognizer.listen(source, timeout=1, phrase_time_limit=10)
                        if audio:
                            audio_data.append(audio)
                            last_audio_time = time.time()
                            print("Audio detected!")  # Debug info
                        elif time.time() - last_audio_time > 5:
                            if audio_data:  # Only stop if we have some audio
                                is_listening = False
                                print("\nProcessing speech after 5 seconds of silence.")
                            else:
                                print("Waiting for speech...")
                    except sr.WaitTimeoutError:
                        if time.time() - last_audio_time > 5 and audio_data:
                            is_listening = False
                            print("\nProcessing speech after 5 seconds of silence.")

            listen_thread = threading.Thread(target=listen_in_background)
            listen_thread.start()

            # Wait for Enter key or for is_listening to become False
            while is_listening:
                if input() == "":
                    is_listening = False
                    print("\nProcessing speech (Enter pressed).")
                    break
                time.sleep(0.1)
            
            listen_thread.join()

        print("Processing speech...")
        full_text = ""
        for i, audio in enumerate(audio_data):
            try:
                text = recognizer.recognize_google(audio, language=language)
                full_text += text + " "
                print(f"Chunk {i+1} recognized")  # Debug info
            except sr.UnknownValueError:
                print(f"Chunk {i+1} not recognized")  # Debug info
            except Exception as e:
                print(f"Error processing chunk {i+1}: {e}")  # Debug info

        if full_text:
            full_text = full_text.strip()
            print("\nRecognized speech:")
            print(full_text)
            return full_text
        else:
            print("No speech was recognized.")
            return None

    except Exception as e:
        print(f"An error occurred: {e}")
        return None

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "rec":
        language = 'nl-NL' if len(sys.argv) > 2 and sys.argv[2] == 'nl' else 'en-US'
        sensitivity = float(sys.argv[3]) if len(sys.argv) > 3 else 1.0
        recognized_text = recognize_speech(language, sensitivity)
        if recognized_text:
            pyperclip.copy(recognized_text)
            print("Text copied to clipboard!")
        print("Script execution completed. Exiting...")
        sys.exit(0)
    else:
        print("Usage: python script.py rec [nl] [sensitivity]")
        print("Add 'nl' to use Dutch language recognition.")
        print("Add a number (e.g., 0.8) to adjust microphone sensitivity (default is 1.0, lower is more sensitive).")
