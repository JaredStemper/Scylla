echo ""
echo ""
echo -e "\e[0;31mInstall tools and update configs?\e[0;32m "
read -r answer

if [ "$answer" == "yes" ] || [ "$answer" == "y" ]; then
    echo -e "\e[0;31mContinuing setup script."
elif [ "$answer" == "no" ] || [ "$answer" == "n" ]; then
    echo -e "\e[0;31mTake your time."
    exit 1
else
    echo -e "\e[0;31mInvalid choice. Please enter 'yes'/'y' or 'no'/'n'."
fi

#prepare tmuxinator for usage
sudo apt update && sudo apt install vim
sudo gem install tmuxinator
echo "alias mux=tmuxinator; alias j='cd ..'">>~/.zshrc && echo "setopt append_history; setopt hist_ignore_dups" >> ~/.zshrc && source ~/.zshrc
echo "alias mux=tmuxinator; alias j='cd ..'">>~/.bash_aliases && echo "setopt append_history; setopt hist_ignore_dups" >> ~/.zshrc && source ~/.bash_aliases
#grab tmuxinator files
git clone https://github.com/JaredStemper/Scylla.git /tmp/Scylla
cp /tmp/Scylla/tmux.conf ~/.tmux.conf

#enable usage of TIOCSTI for prefill tool to work (more details https://bugs.archlinux.org/task/77745 and https://lore.kernel.org/linux-hardening/20221015041626.1467372-2-keescook@chromium.org/
sudo sysctl -w dev.tty.legacy_tiocsti=1

#create crontab to log all data captured in tmux currently on testing device every 15 minutes
(crontab -l ; echo "0,15,30,45 * * * * /bin/bash /tmp/mux/tmuxSessionHistoryCapture.sh") | crontab -

python3 /tmp/Scylla/prefillTest.py "mux start -p /tmp/Scylla/tmuxinator/internalTemplate-initScan.yml msfWorkspace=CLIENTNAME domain=domain.local nessusKey=NESSUSKEY sudoPass='sudoPass'"
