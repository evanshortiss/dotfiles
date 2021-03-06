#
# Performs some initial setup for a Fedora Linux machine.
# Doesn't stick to specific versions...
# Sure it's grand...yolo?
#

# Set Fedora to use the default dark theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.wm.preferences theme "Adwaita-dark"

# Install Docker Engine and Compose. This will pull the latest version of
# Engine, but Compose is s specific tag. GLHF
sudo dnf -y install dnf-plugins-core
sudo dnf -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp - docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl start docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update -y
sudo dnf install code -y

# Installs NVM (Node.js Version Manager) and latest LTS release of Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source ~/.bashrc
nvm install --lts

# Brave browser
sudo dnf install dnf-plugins-core -y
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/ -y
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser -y

# Install and set ZSH as default shell. Normally the chsh utility is used to
# do this, but it's not installed by default on Fedora. Also, some internet
# strangers say chsh has dodgy permissions or something to that effect.
sudo dnf install zsh -y
echo '[ ! -z "$PS1" ] && exec /usr/bin/zsh' >> ~/.bashrc

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Download various dotfiles from this repo into the homedir on the Fedora machine
curl https://raw.githubusercontent.com/evanshortiss/dotfiles/master/.gitconfig > ~/.gitconfig
curl https://raw.githubusercontent.com/evanshortiss/dotfiles/master/.editorconfig > ~/.editorconfig
curl https://raw.githubusercontent.com/evanshortiss/dotfiles/master/.zshrc > ~/.zshrc
curl https://raw.githubusercontent.com/evanshortiss/dotfiles/master/.gitignore > ~/.gitignore
curl https://raw.githubusercontent.com/evanshortiss/dotfiles/master/.npmrc > ~/.npmrc

# Super important. Install Spotify for some "choons". I'm not sure what the best
# way to go about installing it is. RPMs seem hit and miss but this does the trick
sudo flatpak install -y --from https://flathub.org/repo/appstream/com.spotify.Client.flatpakref
sudo dnf install -y flatpak

echo "All done! Close this terminal session and start a new one."
echo "Hopefully everything worked out •ᴗ•"
