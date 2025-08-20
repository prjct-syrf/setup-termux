#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

title() { echo -e "\n\033[1;36m==> $*\033[0m"; }

# 0) Cek koneksi & refresh keyring
title "Cek koneksi & sync repos"
pkg update -y || true
yes | pkg upgrade -y || true

# 1) Repos opsional (banyak tool ada di sini)
title "Aktifkan repos tambahan (root/unstable/x11/science)"
for r in root-repo unstable-repo x11-repo science-repo; do
  pkg install -y "$r" || true
done

# 2) Paket dasar & utilitas
title "Install paket dasar"
pkg install -y \
  git curl wget aria2 nano vim tmux openssh \
  zip unzip tar p7zip rclone jq htop neofetch \
  termux-tools termux-api

# 3) Build & Dev toolchains
title "Install toolchain & bahasa pemrograman"
pkg install -y \
  build-essential clang make cmake gdb pkg-config \
  python python-pip nodejs rust golang

# 4) Networking / diagnostic
title "Install paket jaringan"
pkg install -y \
  net-tools inetutils nmap tcpdump socat openssl

# 5) Media & image processing (opsional tapi berguna)
title "Install media tools"
pkg install -y ffmpeg imagemagick

# 6) proot-distro untuk Linux userspace
title "Install proot & proot-distro"
pkg install -y proot proot-distro

# 7) Akses storage Android
title "Aktifkan akses storage (butuh konfirmasi)"
termux-setup-storage || true

# 8) Python & Node global helpers (aman di userland)
title "Install pip & npm util berguna"
pip install --upgrade pip wheel setuptools
pip install --user httpie yt-dlp
npm -g install npm@latest tldr

# 9) Sentuhan akhir
title "Bersih-bersih cache"
pkg autoclean

echo -e "\n\033[1;32mSelesai! Rekomendasi lanjutan:\033[0m"
echo "- Jalankan: proot-distro list   # lihat distro yang tersedia"
echo "- Jalankan: tldr --update       # update database tldr"