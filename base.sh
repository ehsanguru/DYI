#!/bin/bash
set -euo pipefail

# --- CONFIGURATION ---
NEW_USER="sysadm"
SSH_KEY="<SSH_PUB_KEY>"
TS_KEY="tskey-auth-kMxZHa2ykR11CNTRL-bEP3JHZsDPGyXS33CRcHPGPHmvhyoV1aa"
CUSTOM_SSH_PORT=2222  # Change this to your preferred port (1024-65535)

# --- 1. SYSTEM UPDATES & BASIC TOOLS ---
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y
apt-get install -y curl wget git vim htop ufw unattended-upgrades

# Enable daily automated security updates
echo "unattended-upgrades unattended-upgrades/enable_auto_updates boolean true" | debconf-set-selections
dpkg-reconfigure -plow unattended-upgrades

# --- 2. NETWORK OPTIMIZATION (BBR) ---
cat <<EOF >> /etc/sysctl.conf
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
EOF
sysctl -p

# --- 3. USER SETUP & PASSWORDLESS SUDO ---
useradd -m -s /bin/bash "$NEW_USER"
usermod -aG sudo "$NEW_USER"
echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$NEW_USER"

# --- 4. HARDEN OPENSSH & CUSTOM PORT ---
mkdir -p "/home/$NEW_USER/.ssh"
echo "$SSH_KEY" > "/home/$NEW_USER/.ssh/authorized_keys"
chown -R "$NEW_USER:$NEW_USER" "/home/$NEW_USER/.ssh"
chmod 700 "/home/$NEW_USER/.ssh"
chmod 600 "/home/$NEW_USER/.ssh/authorized_keys"

# Configure OpenSSH for custom port and key-only auth
cat <<EOF > /etc/ssh/sshd_config.d/99-hardened.conf
Port $CUSTOM_SSH_PORT
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
EOF
systemctl restart ssh

# --- 5. TAILSCALE SETUP ---
curl -fsSL https://tailscale.com | sh
# Joins tailnet and enables Tailscale SSH (which still uses port 22 internally)
tailscale up --auth-key="$TS_KEY" --ssh --hostname="$NEW_USER-host"

# --- 6. UFW FIREWALL LOCKDOWN ---
ufw default deny incoming
ufw default allow outgoing

# Allow Tailscale traffic (including Tailscale SSH on port 22)
ufw allow in on tailscale0
ufw allow 41641/udp

# Allow standard SSH only on the CUSTOM port (optional: limit to Tailscale range)
ufw allow $CUSTOM_SSH_PORT/tcp

ufw --force enable
