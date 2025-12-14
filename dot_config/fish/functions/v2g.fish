function v2g
    # Default values
    set src ""
    set target ""
    set resolution ""
    set fps 10

    # Local copy of arguments for processing
    set -l args $argv

    # Process each argument
    while test (count $args) -gt 0
        switch $args[1]
            case --src
                if test (count $args) -gt 1
                    set src $args[2]
                    set args $args[3..-1]
                else
                    echo "Error: --src requires an argument."
                    return 1
                end
            case --target
                if test (count $args) -gt 1
                    set target $args[2]
                    set args $args[3..-1]
                else
                    echo "Error: --target requires an argument."
                    return 1
                end
            case --resolution
                if test (count $args) -gt 1
                    set resolution $args[2]
                    set args $args[3..-1]
                else
                    echo "Error: --resolution requires an argument."
                    return 1
                end
            case --fps
                if test (count $args) -gt 1
                    set fps $args[2]
                    set args $args[3..-1]
                else
                    echo "Error: --fps requires an argument."
                    return 1
                end
            case '*'
                # Skip unknown arguments
                set args $args[2..-1]
        end
    end

    # Check that src is provided
    if test -z "$src"
        echo "\nPlease call 'v2g --src <source video file>' to run this command\n"
        return 1
    end

    # Default target: if not provided, same as src
    if test -z "$target"
        set target $src
    end

    # Remove any extension from target to generate basename.
    # Using single quotes for the regex avoids issues with $.
    set basename (string replace -r '\.[^\.]+$' "" -- $target)
    if test -z "$basename"
        set basename $target
    end
    set target "$basename.gif"

    # Prepare ffmpeg arguments as a list.
    if test -n "$fps"
        set fps_arg -r $fps
    else
        set fps_arg
    end

    if test -n "$resolution"
        set res_arg -s $resolution
    else
        set res_arg
    end

    # Display the command (for debugging)
    echo "ffmpeg -i \"$src\" -pix_fmt rgb8" $fps_arg $res_arg "\"$target\""
    
    # Execute ffmpeg and then optimize the gif with gifsicle
    ffmpeg -i "$src" -pix_fmt rgb8 $fps_arg $res_arg "$target" && \
        gifsicle -O3 "$target" -o "$target"

    # Use osascript to show a macOS notification (if applicable)
    osascript -e "display notification \"$target successfully converted and saved\" with title \"v2g complete\""
end

