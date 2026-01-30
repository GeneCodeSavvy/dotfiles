#!/usr/bin/env bash

# === 1. BASIC SETUP AND DEPENDENCIES ===

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

# === 2. NODE/NVM SETUP ===
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

# === 3. GO LANG SETUP (Source Build) ===
## download and set up the bootstrap compiler
cd ~
## download the specific, known-working bootstrap version for arm64
wget https://go.dev/dl/go1.25.2.linux-arm64.tar.gz
sudo rm -rf go
sudo tar -C /usr/local -xzf go1.25.3.linux-amd64.tar.gz
# set the PATH for the current user and session
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
# Clean up the bootstrap files
cd ~
sudo rm -rf go-bootstrap go1.25.2.linux-arm64.tar.gz
# install a standard Go tool (gopls)
go install golang.org/x/tools/gopls@latest

# === 4. PROJECT & PM2 SETUP ===
# setting up config files
cd ~
mv dotfiles .config

# installing and setting up pm2
npm install pm2@latest -g
STARTUP_COMMAND=$(pm2 startup systemd | tail -n 1)
eval "$STARTUP_COMMAND"

# === 5. CADDY & XCADDY SETUP (Custom Build) ===
go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
xcaddy build --with github.com/mholt/caddy-ratelimit
sudo mv caddy /usr/local/bin/

# === 6. ROBUST IPTABLES CONFIGURATION (THE FIX) ===
echo "Applying robust iptables rules..."

# Insert the ACCEPT rules at the beginning of the chain (position 1) to ensure they are processed first.
# This prevents them from being skipped by any subsequent general REJECT/DROP rule.
# We are inserting at line 1, so subsequent rules shift down.
sudo iptables -I INPUT 1 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 1 -m state --state NEW -p tcp --dport 443 -j ACCEPT
echo "Inserted Port 80 and 443 ACCEPT rules at the top of the INPUT chain."

# Optional: Ensure iptables rules persist across reboots (required for most Ubuntu systems)
sudo apt install -y iptables-persistent
sudo iptables-save | sudo tee /etc/iptables/rules.v4
echo "Saved iptables rules for persistence."

# === 7. FINAL STEP ===
# reboot the system
sudo reboot
