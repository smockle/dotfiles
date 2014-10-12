#!/usr/bin/env sh

##
## In an elevated cmd.exe with administrator privileges:
##

# Install chocolatey.
# @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

# Install git and node
cinst git
cinst nodejs
export PATH="C:\ProgramData\chocolatey\lib\nodejs.commandline.0.10.32\tools:$PATH"
npm install -g windosu

##
## In a regular Git for Windows Bash terminal:
##

# Install git tools
sudo npm install -g npm@latest
sudo cinst git-credential-winstore
export PATH="C:\ProgramData\chocolatey\lib\git-credential-winstore.1.2.0.0\lib\net40-Client:$PATH"
git-credential-winstore

# Install other software
sudo cinst 7zip atom GoogleChrome.Canary make nano ruby
sudo cinst VisualStudio2013Ultimate -InstallArguments "/Features:'SQL WebTools'"

# Copy SSH keys
start ~/.ssh

# Install hub
mkdir ~/Projects && cd "$_"
git clone git://github.com/github/hub.git
cd hub
rake install

# Install fasd
cd ~/Projects
git clone clvv/fasd
make install
mkdir ~/bin && cd "$_"
ln -s ~/Projects/fasd/fasd ~/bin/fasd
wget "http://downloads.sourceforge.net/project/mingw/MSYS/Extension/mktemp/mktemp-1.6-2/mktemp-1.6-2-msys-1.0.13-bin.tar.lzma?r=&ts=1413107452&use_mirror=hivelocity"
# Extract mktemp to ~/bin

# Clone dotfiles
cd ~/Projects
git clone smockle/dotfiles
rm ~/.bash_profile ~/.bashrc ~/.gemrc ~/.gitconfig ~/.gitignore ~/.hushlogin ~/.irbrc ~/.pylintrc ~/.sshconfig
ln -s ~/Projects/dotfiles/.bash_profile ~/.bash_profile
ln -s ~/Projects/dotfiles/.bashrc ~/.bashrc
ln -s ~/Projects/dotfiles/.gemrc ~/.gemrc
ln -s ~/Projects/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/Projects/dotfiles/.gitignore ~/.gitignore
ln -s ~/Projects/dotfiles/.hushlogin ~/.hushlogin
ln -s ~/Projects/dotfiles/.irbrc ~/.irbrc
ln -s ~/Projects/dotfiles/.pylintrc ~/.pylintrc
ln -s ~/Projects/dotfiles/.sshconfig ~/.sshconfig

# Update hosts file
sudo mv /c/Windows/system32/drivers/etc/hosts ~/Projects/dotfiles/hosts.bak
sudo cp ~/Projects/dotfiles/hosts /c/Windows/system32/drivers/etc/hosts
