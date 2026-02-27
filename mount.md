sudo xbps-install -S ntfs-3g

#### get user id
lsblk -f

sudo mkdir -p /mnt/win1
sudo mkdir -p /mnt/win2
sudo mkdir -p /mnt/win3

sudo nvim /etc/fstab

UUID=5AC61556C615342B  /mnt/win1  ntfs3  rw,uid=1000,gid=1000,umask=022  0  0
UUID=9A4E70324E7008F1  /mnt/win2  ntfs3  rw,uid=1000,gid=1000,umask=022  0  0
UUID=9AE67510E674EE3F  /mnt/win3  ntfs3  rw,uid=1000,gid=1000,umask=022  0  0


sudo mount -t ntfs-3g /dev/sda1 /mnt/sda1
sudo mount -t ntfs-3g /dev/sda2 /mnt/sda2
sudo mount -t ntfs-3g /dev/sda7 /mnt/sda7

sudo mount -t ntfs-3g /dev/sda5 /mnt/win5
sudo mount -t ntfs-3g /dev/sda6 /mnt/win6

### with file manager 

> install pacakge
  sudo xbps-install -S udisks2 ntfs-3g udiskie
> enable service
  sudo ln -s /etc/sv/udisks2 /var/service/
> check it is running
  sv status udisks2
> in i3
  exec --no-startup-id udiskie
