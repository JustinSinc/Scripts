#!/bin/zsh
mv ~/.zshrc ~/.zshrc.old
cp -r /home/public/.oh-my-zsh ~/
cp /home/public/.zshrc.oh-my-zsh ~/.zshrc
chown -R $(whoami) ~/.oh-my-zsh
chown -R $(whoami) ~/.zshrc
clear
echo -e "\nOh-my-zsh installed!
Reload your shell with 'source ~/.zshrc' or by logging back in
to complete the installation.\n"
