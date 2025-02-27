function ks
    # Check if an argument was provided
    if test -z "$argv"
        echo "Usage: ks [process_name]"
        return 1
    end
    
    # Kill the process
    pkill $argv
    
    # Start the process again in the background
    $argv &
    
    # Disown the process so it continues running after the terminal closes
    disown

    exit
end
