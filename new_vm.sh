#!/usr/bin/env bash

# ghostty clear command
echo 'export TERM=xterm-256color' >> ~/.bashrc

# Update package lists
sudo apt update
sudo apt upgrade -y

# installing neovim : https://github.com/neovim/neovim/blob/master/BUILD.md#building
sudo apt-get install ninja-build gettext cmake curl build-essential -y
cd ~ && git clone https://github.com/neovim/neovim
cd neovim && git checkout stable
make CMAKE_BUILD_TYPE=Release
sudo make install

# Return to home directory after Neovim install
cd ~

# installing nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Load nvm into the current shell session for immediate use (CRUCIAL FIX)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest node and set it as the default
nvm install node
nvm alias default node

# setting up python
sudo apt install python3-pip python3-venv -y

# installing and setting up Go from source, including necessary bootstrap.
## download and set up the bootstrap compiler
cd ~
## download the specific, known-working bootstrap version for arm64
wget https://go.dev/dl/go1.25.2.linux-arm64.tar.gz
## extract the bootstrap files and rename the directory
sudo tar -C . -xzf go1.25.2.linux-arm64.tar.gz
mv go go-bootstrap
## set the environment variable for the build process
export GOROOT_BOOTSTRAP=$HOME/go-bootstrap
## get the Go source code
cd /usr/local/
## Optional cleanup of any previous installation
sudo rm -rf go 
## Clone the latest Go source code
sudo git clone https://go.googlesource.com/go
cd go/src/
git checkout master
## use the downloaded bootstrap to compile the new toolchain
sudo ./make.bash
# set the PATH for the current user and session
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
# Clean up the bootstrap files
cd ~
sudo rm -rf go-bootstrap go1.25.2.linux-arm64.tar.gz
# install a standard Go tool (gopls)
go install golang.org/x/tools/gopls@latest

# setting up config files
cd ~
mv dotfiles .config

# installing and setting up pm2
npm install pm2@latest -g
STARTUP_COMMAND=$(pm2 startup systemd | tail -n 1)
eval "$STARTUP_COMMAND"

# setting up xcaddy, for caddy custom builds
go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
xcaddy build --with github.com/mholt/caddy-ratelimit
sudo mv caddy /usr/local/bin/

# reboot the system
sudo reboot
