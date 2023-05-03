FROM archlinux:base-devel

RUN pacman-key --init && \
  pacman-key --populate archlinux

RUN cat <<EOF >> /etc/pacman.conf
[usa-reddragon]
SigLevel = Required TrustedOnly
Server = https://raw.githubusercontent.com/USA-RedDragon/arch-packages/bins/x86_64
EOF

RUN curl -fSsLo /tmp/usa-reddragon-keyring-20230501-5-any.pkg.tar.zst https://github.com/USA-RedDragon/arch-packages/raw/bins/x86_64/usa-reddragon-keyring-20230501-5-any.pkg.tar.zst && \
  pacman --noconfirm -U /tmp/usa-reddragon-keyring-20230501-5-any.pkg.tar.zst && \
  rm -f /tmp/usa-reddragon-keyring-20230501-5-any.pkg.tar.zst

RUN pacman --noconfirm -Syyu --needed git devtools dbus sudo usa-reddragon-keyring
RUN useradd -m user || true
RUN mkdir -p /home/user/.gnupg
RUN chown -R user:user /home/user
RUN dbus-uuidgen --ensure=/etc/machine-id
RUN sed -i "s|MAKEFLAGS=.*|MAKEFLAGS=-j$(nproc)|" /etc/makepkg.conf

# Add the user to the sudoers list
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
