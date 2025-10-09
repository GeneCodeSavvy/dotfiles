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

# installing and setting up go
sudo apt install golang-go -y
echo "export PATH=$PATH:$(go env GOPATH)/bin" >> ~/.bashrc

# setting up config files
cd ~
mv dotfiles .config

# installing and setting up pm2
npm install pm2@latest -g
STARTUP_COMMAND=$(pm2 startup systemd | tail -n 1)
eval "$STARTUP_COMMAND"

# setting up xcaddy, for caddy custom builds
go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# reboot the system
sudo reboot
