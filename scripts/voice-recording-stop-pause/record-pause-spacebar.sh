                stop_recording
                is_paused=true
            fi
            ;;
        $'\n')  # Enter key
            break
            ;;
    esac
done

# Restore terminal settings
stty echo
stty cooked

cleanup
