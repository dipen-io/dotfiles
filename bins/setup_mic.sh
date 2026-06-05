#!/bin/sh
# ===========================================
# Mic Setup Script for Void Linux
# Realtek ALC256 / HDA Intel PCH
# ===========================================

echo "==> Setting correct capture source (Internal Mic 1)..."
amixer -c 0 cset numid=6 2 > /dev/null
amixer -c 0 cset numid=9 3,3 > /dev/null  # Internal Mic Boost max
amixer -c 0 cset numid=8 on,on > /dev/null # Capture Switch on
amixer -c 0 cset numid=11 3,3 > /dev/null  # Internal Mic Boost 1 max
echo "    Done."

echo "==> Unmuting PipeWire source..."
wpctl set-mute @DEFAULT_SOURCE@ 0
wpctl set-volume @DEFAULT_SOURCE@ 1.0
echo "    Done."

echo "==> Saving ALSA state..."
sudo alsactl store
echo "    Done."

echo "==> Setting up alsa runit service for boot persistence..."
sudo mkdir -p /etc/sv/alsa
sudo tee /etc/sv/alsa/run > /dev/null << 'EOF'
#!/bin/sh
exec alsactl restore
EOF
sudo chmod +x /etc/sv/alsa/run

if [ ! -L /var/service/alsa ]; then
    sudo ln -sf /etc/sv/alsa /var/service/alsa
    echo "    Alsa runit service enabled."
else
    echo "    Alsa runit service already enabled."
fi

echo ""
echo "================================================"
echo " All done! Settings saved."
echo " A reboot is required for all changes to apply."
echo ""
echo " After reboot, test your mic with:"
echo "   pw-record /tmp/test.wav & sleep 5 && kill %1 && pw-play /tmp/test.wav"
echo "================================================"
echo ""
printf "Reboot now? (y/n): "
read answer
if [ "$answer" = "y" ]; then
    sudo reboot
fi
