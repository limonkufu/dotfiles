function fish_greeting
host -t txt istheinternetonfire.com | cut -f 2 -d '"' | cowsay -f vader
# Only run fortune ~40% of the time
    if test (random) -lt 9999
        fortune -a | cowsay -f stegosaurus
    end
end