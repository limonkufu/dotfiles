function gttyc
  set SHADERS_DIR "$HOME/dev/ghostty-shaders"
  set CONFIG_FILE "$HOME/.config/ghostty/shaders"
  set PREFIX "custom-shader = \"$SHADERS_DIR"

  # Find shader files
  set shaders (fd --type f -e glsl --base-directory "$SHADERS_DIR")

  if test -z "$shaders"
    echo "No shader files found in $SHADERS_DIR" >&2
    return 1
  end

  # Select shader file using fzf
  set selected (
    for shader in $shaders
      echo $shader
    end | fzf --preview "cat '{}'" --delimiter=/
  )

  if test -z "$selected"
    echo "No shader selected" >&2
    return 1
  end

  # Update Ghostty configuration
  set -l line_to_toggle "$PREFIX/$selected\""
  echo "Line to toggle: $line_to_toggle" >&2
  
  # Escape forward slashes in the line_to_toggle for sed
  set escaped_line_to_toggle (string replace -a "/" "\\/" $line_to_toggle)
  echo "Escaped Line to toggle: $escaped_line_to_toggle" >&2
  
  if grep -q "^# $escaped_line_to_toggle" $CONFIG_FILE
    # Line is commented, so uncomment it
    sed -i "s/^# $escaped_line_to_toggle/$escaped_line_to_toggle/" $CONFIG_FILE
  else
    # Line is not commented, so comment it
    sed -i "s/^$escaped_line_to_toggle/# $escaped_line_to_toggle/" $CONFIG_FILE
  end


  # Reload Ghostty configuration
  osascript -so \
    -e 'tell application "Ghostty" to activate' \
    -e 'tell application "System Events" to keystroke "," using {command down, shift down}'

  echo "Ghostty configuration updated to: $selected"
end

function gttycn
	bash /Users/u.yilmaz/dev/ghostty-shaders/synclinks.sh
	osascript -so \
    -e 'tell application "Ghostty" to activate' \
    -e 'tell application "System Events" to keystroke "," using {command down, shift down}'
end
