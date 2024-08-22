#!/bin/bash

# Initialize vars
rootDir=""
rootUser=""
tmuxConf=""
logging=""

# Function to prompt the user until they answer 'yes'
ask_question_y_n() {
    local question=$1
    local answer_var=$2

    while true; do
        read -p "$question (yes/no): " user_input

        if [ "$user_input" == "yes" ] || [ "$user_input" == "y" ]; then
            eval $answer_var="$user_input"
            break
        elif [ "$user_input" == "no" ] || [ "$user_input" == "n" ]; then
            eval $answer_var="$user_input"
            break
        else
            echo -e "\e[0;31mInvalid choice. Enter 'yes'/'y' or 'no'/'n'... pls"
        fi
    done
}

ask_question_gen_response() {
    local question=$1
    local answer_var=$2

    while true; do
        read -p "$question: " user_input

        if [ -n "$user_input" ]; then
            eval $answer_var="$user_input"
            break
        else
            echo -e "\e[0;31mPlease provide a valid path... pls"
        fi
    done
}

# Ask questions
ask_question_gen_response "What directory are you testing in (e.g., /encryptedPartition/clientFolder) (creates automatically if it doesn't exist)?" rootDir
ask_question_y_n "Are you testing as the root user?" rootUser
ask_question_y_n "Do you want to use the optimized Scylla tmux.conf or the current/default tmux.conf (note: will cp old one to ~/.tmux.conf.archive for posterity)?" tmuxConf
ask_question_y_n "Do you want automated logging performed to capture all commands/output ran in Scylla?" logging

# Print the answers
echo "Answer to question 1: $rootDir"
echo "Answer to question 2: $rootUser"
echo "Answer to question 3: $tmuxConf"
echo "Answer to question 4: $logging"

if [ -n "$rootDir" ]; then
    mkdir -p "$rootDir"
    cd "$rootDir"
    #grab tmuxinator files
    git clone https://github.com/JaredStemper/Scylla.git "$rootDir/Scylla"
fi
# if root user, remove sudoPass from templates/prefills to avoid errors
if [ "$rootUser" == "yes" ] || [ "$rootUser" == "y" ]; then
    for template in $(ls $rootDir/Scylla/tmuxinator/*.yml); do sed -i '/sudo -S su/d' "$template"; done
    sed -i "s/sudoPass=<%= @settings\[\"sudoPass\"\] %> //" $rootDir/Scylla/tmuxinator/internalTemplate-initScan.yml
fi
# if using Scylla config, set new defaul and keeping an archive of old conf
if [ "$tmuxConf" == "yes" ] || [ "$tmuxConf" == "y" ]; then
    cp ~/.tmux.conf ~/.tmux.conf.archive
    cp "$rootDir/Scylla/tmux.conf" ~/.tmux.conf
fi
# if logging, create a crontab to log all data captured in tmux currently on testing device every 15 minutes
if [ "$logging" == "yes" ] || [ "$logging" == "y" ]; then
    (crontab -l ; echo "0,15,30,45 * * * * /bin/bash \"$rootDir/Scylla/tmuxSessionHistoryCapture.sh\"") | crontab -
fi

# prepare tmuxinator for usage
sudo apt update && sudo apt install vim
sudo gem install tmuxinator

# add shell-specific config
local user_shell=$(echo $SHELL)
if [ "$user_shell" == "/bin/bash" ]; then
    echo "alias mux=tmuxinator; alias j='cd ..'; setopt append_history; setopt hist_ignore_dups" >> ~/.bash_aliases && source ~/.bash_aliases 2>/dev/null
    # Add your bash-specific actions here
elif [ "$user_shell" == "/bin/zsh" ]; then
    echo "alias mux=tmuxinator; alias j='cd ..'; setopt append_history; setopt hist_ignore_dups" >> ~/.zshrc && source ~/.zshrc 2>/dev/null
else
    echo "if not using /bin/bash or /bin/zsh you will need to add the following to your shell profile for ease of use in tmux"
    echo "      alias mux=tmuxinator; alias j='cd ..'; setopt append_history; setopt hist_ignore_dup"
fi

#enable usage of TIOCSTI for prefill tool to work (more details https://bugs.archlinux.org/task/77745 and https://lore.kernel.org/linux-hardening/20221015041626.1467372-2-keescook@chromium.org/
sudo sysctl -w dev.tty.legacy_tiocsti=1

if [ "$rootUser" == "yes" ] || [ "$rootUser" == "y" ]; then
    python3 $rootDir/Scylla/prefillTest.py "tmuxinator start -p $rootDir/Scylla/tmuxinator/internalTemplate-initScan.yml msfWorkspace=CLIENTNAME domain=domain.local nessusKey=NESSUSKEY"
else
    python3 $rootDir/Scylla/prefillTest.py "tmuxinator start -p $rootDir/Scylla/tmuxinator/internalTemplate-initScan.yml msfWorkspace=CLIENTNAME domain=domain.local nessusKey=NESSUSKEY sudoPass='sudoPass'"
fi
