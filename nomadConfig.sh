#to be ran after `nomad-mount` inside of /RSM
echo ""
echo ""
echo -e "\e[0;31mHas nomad-mount been ran?\e[0;32m "
read -r answer

if [ "$answer" == "yes" ] || [ "$answer" == "y" ]; then
    echo -e "\e[0;31mContinuing setup script."
elif [ "$answer" == "no" ] || [ "$answer" == "n" ]; then
    echo -e "\e[0;31mPlease run nomad-mount before running config script."
    exit 1
else
    echo -e "\e[0;31mInvalid choice. Please enter 'yes'/'y' or 'no'/'n'."
fi

#fix permissions error
sudo chown -R nomad /RSM

#prepare tmuxinator for usage
sudo apt update && sudo apt upgrade -y && sudo apt install vim
sudo gem install tmuxinator
echo "alias mux=tmuxinator; alias j='cd ..'>>~/.zshrc && echo "setopt append_history; setopt hist_ignore_dups" >> ~/.zshrc && source ~/.zshrc
echo "alias mux=tmuxinator; alias j='cd ..'>>~/.bash_aliases && echo "setopt append_history; setopt hist_ignore_dups" >> ~/.zshrc && source ~/.bash_aliases
#grab tmuxinator files
cd /RSM
git clone https://github.com/JaredStemper/mux.git
cp /RSM/mux/tmux.conf ~/.tmux.conf

#enable usage of TIOCSTI for prefill tool to work (more details https://bugs.archlinux.org/task/77745 and https://lore.kernel.org/linux-hardening/20221015041626.1467372-2-keescook@chromium.org/
sudo sysctl -w dev.tty.legacy_tiocsti=1

#create crontab to log all data captured in tmux currently on nomad every 15 minutes
(crontab -l ; echo "0,15,30,45 * * * * /bin/bash /RSM/mux/tmuxSessionHistoryCapture.sh") | crontab -

cd /RSM; clear

python3 /RSM/mux/prefillTest.py "mux start -p /RSM/mux/tmuxinator/internalTemplate-initScan.yml msfWorkspace=CLIENTNAME domain=domain.local nessusKey=NESSUSKEY nomadPass='nomadPass'"
