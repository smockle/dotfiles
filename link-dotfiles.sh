#!/usr/bin/env sh

platform=''
case "$OSTYPE" in
  solaris*) platform='solaris' ;;
  darwin*)  platform='osx' ;;
  linux*)   platform='linux' ;;
  bsd*)     platform='bsd' ;;
  *)        platform='windows' ;;
esac

rm ~/.bash_prompt
ln -s ~/Projects/dotfiles/.bash_prompt ~/.bash_prompt

rm ~/.bash_profile
ln -s ~/Projects/dotfiles/.bash_profile ~/.bash_profile

rm ~/.bashrc
ln -s ~/Projects/dotfiles/.bashrc ~/.bashrc

rm ~/.gemrc
ln -s ~/Projects/dotfiles/.gemrc ~/.gemrc

rm ~/.gitconfig
ln -s ~/Projects/dotfiles/.gitconfig ~/.gitconfig
if [[ $platform == 'windows' ]]; then
  git config --global credential.helper "!'C:\\Users\\Clay\\AppData\\Roaming\\GitCredStore\\git-credential-winstore.exe'"
fi

rm ~/.hushlogin
ln -s ~/Projects/dotfiles/.hushlogin ~/.hushlogin

rm ~/.inputrc
ln -s ~/Projects/dotfiles/.inputrc ~/.inputrc

rm ~/.irbrc
ln -s ~/Projects/dotfiles/.irbrc ~/.irbrc

rm ~/.powconfig
ln -s ~/Projects/dotfiles/.powconfig ~/.powconfig

rm ~/.pylintrc
ln -s ~/Projects/dotfiles/.pylintrc ~/.pylintrc

rm ~/.sshconfig
ln -s ~/Projects/dotfiles/.sshconfig ~/.sshconfig

rm ~/.tidyrc
ln -s ~/Projects/dotfiles/.tidyrc ~/.tidyrc
