#!/bin/bash

# First, use this boot/cmdline.txt
cat > /boot/cmdline.txt << 'endmsg'
dwc_otg.lpm_enable=0 console=tty1 console=ttyAMA0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait fbcon=map:10 fbcon=font:ProFont6x11 logo.nologo
endmsg

# Next, add this bit to the boot/config.txt file
cat >> /boot/config.txt << 'endmsg'
dtparam=audio=on
dtparam=spi=on
dtoverlay=ads7846,penirq=25,penirq_pull=2,xohms=150,swapxy=1,xmin=300,ymin=700,xmax=3800,ymax=3400,pmax=255
dtoverlay=waveshare35a
endmsg

# Download the drivers for the screen from github
wget https://github.com/swkim01/waveshare-dtoverlays/raw/master/waveshare35a-overlay.dtb /boot/overlays/waveshare35a.dtbo

# Add this section to 99-fbturbo.conf
cat >> /usr/share/X11/xorg.conf.d/99-fbturbo.conf << 'endmsg'
Section "Device"
Identifier "Allwinner A10/A13 FBDEV"
Driver "fbturbo"
Option "fbdev" "/dev/fb1"

Option "SwapbuffersWait" "true"
EndSection
endmsg

# Add this file in xorg.conf.d
cat > /etc/X11/xorg.conf.d/99-calibration.conf << 'endmsg'
Section "InputClass"
Identifier "calibration"
MatchProduct "ADS7846 Touchscreen"
Option "Calibration" "3932 300 294 3801"
Option "SwapAxes" "1"
EndSection
endmsg

# Reboot the raspberry pi and you should be good to go.
reboot
