#!/bin/bash
set -e

RDP_USER="${RDP_USER:-linuxuser}"
RDP_PASSWORD="${RDP_PASSWORD:?ضع RDP_PASSWORD في Railway Variables}"

if ! id "$RDP_USER" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$RDP_USER"
fi

echo "$RDP_USER:$RDP_PASSWORD" | chpasswd
usermod -aG sudo "$RDP_USER"
adduser "$RDP_USER" ssl-cert || true

echo "startxfce4" > "/home/$RDP_USER/.xsession"
chown "$RDP_USER:$RDP_USER" "/home/$RDP_USER/.xsession"

# تشغيل الخدمات المطلوبة داخل الـContainer
service dbus start || true
/usr/sbin/xrdp-sesman --nodaemon &
exec /usr/sbin/xrdp --nodaemon
