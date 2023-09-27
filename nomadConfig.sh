#to be ran after `nomad-mount` inside of /RSM

#fix permissions error
sudo chmod -R 777 /RSM

#prepare tmuxinator for usage
sudo apt update && sudo apt upgrade -y && sudo apt install vim
sudo gem install tmuxinator
echo "alias mux=tmuxinator">>~/.zshrc && echo "setopt append_history; setopt hist_ignore_dups" >> ~/.zshrc && source ~/.zshrc
echo "alias mux=tmuxinator">>~/.bash_aliases && echo "setopt append_history; setopt hist_ignore_dups" >> ~/.zshrc && source ~/.bash_aliases
#grab tmuxinator files
cd /RSM
git clone https://github.com/JaredStemper/mux.git
cp /RSM/mux/tmux.conf ~/.tmux.conf
mv /RSM/mux/prefillTest.py /RSM/prefillTest.py
mv /RSM/mux/tmuxSessionHistoryCapture.sh /RSM/tmuxSessionHistoryCapture.sh

#enable usage of TIOCSTI for prefill tool to work (more details https://bugs.archlinux.org/task/77745 and https://lore.kernel.org/linux-hardening/20221015041626.1467372-2-keescook@chromium.org/
sudo sysctl -w dev.tty.legacy_tiocsti=1

#create crontab to log all data captured in tmux currently on nomad every 15 minutes
(crontab -l ; echo "0,15,30,45 * * * * /bin/bash /RSM/tmuxSessionHistoryCapture.sh") | crontab -

cd /RSM; clear

python3 /RSM/prefillTest.py "mux start -p /RSM/mux/tmuxinator/internalTemplate-initScan.yml client=CLIENTNAME domain=domain.local nessusKey=NESSUSKEY nomadPass='nomadPass' providedUser=providedUser providedPass='providedPass'"
