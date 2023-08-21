#to be ran after `nomad-mound`

sudo chmod -R 777 /RSM
wget https://raw.githubusercontent.com/JaredStemper/Scripts/main/nested.tmux.conf -O /RSM/.tmux.conf
sudo gem install tmuxinator
echo "alias mux=tmuxinator">>~/.zshrc && echo "setopt append_history; setopt hist_ignore_dups" >> ~/.zshrc && source ~/.zshrc
mkdir -p ~/.config/tmuxinator
mv /RSM/tmuxinator/*.yml ~/.config/tmuxinator/

cd /RSM

