function fish_greeting
host -t txt istheinternetonfire.com | cut -f 2 -d '"' | cowsay -f vader
# Only run fortune ~20% of the time
    if test (random) -lt 6553
        fortune -a | cowsay -f fox
    end
end