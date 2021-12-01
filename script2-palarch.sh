echo "romanos installer
echo "0.2 ALPHA"
echo "Instalacion en SDA"
cfdisk /dev/sda
mkfs.ext4 /dev/sda2
mkfs.fat -F 32 /dev/sda1
echo "MONTAJE DE PARTICIONES"
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
echo "DESCARGA DEL SISTEMA OPERATIVO..."
pacstrap /mnt base base-devel git wget curl linux linux-firmware grub os-prober efibootmgr networkmanager dhcpcd netctl wpa_supplicant dialog firefox libreoffice-fresh libreoffice-fresh-es hunspell-es_any hunspell-es_mx gnome wayland
echo "GENERAR FSTAB"
genfstab /mnt
genfstab /mnt >> /mnt/etc/fstab
echo "ENTRAR EN CHROOT"
cp /romanos-arch-installer/chrootinstaller.sh /mnt/
chmod +x /mnt/chrootinstaller.sh
arch-chroot /mnt /chrootinstaller.sh
