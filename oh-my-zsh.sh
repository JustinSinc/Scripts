#!/bin/bash
echo "Installing zsh..."
if type apt-get > /dev/null; then
  sudo apt-get -y install zsh python python-pip python-dev curl
elif type pacman > /dev/null; then
  sudo pacman -S zshrc python python-pip curl
fi
echo "Installing oh-my-zsh..."
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
echo "Installing thefuck..."
sudo pip install thefuck
echo "Installing zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/zsh-syntax-highlighting
echo "Grabbing ~/.zshrc from my repo..."
wget https://raw.githubusercontent.com/JustinSinc/shells/master/.zshrc.oh-my-zsh -O ~/.zshrc
echo "Grabbing modified fishy.zsh-theme from my repo..."
wget https://raw.githubusercontent.com/JustinSinc/dotfiles/master/fishy.zsh-theme -O ~/.oh-my-zsh/themes/fishy.zsh-theme
echo "Changing shell to /usr/bin/zsh..."
chsh -s $(which zsh)
clear
echo "Log out and back in for changes to take effect."
