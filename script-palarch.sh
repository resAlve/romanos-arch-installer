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
pacstrap /mnt base base-devel git wget curl linux linux-firmware grub os-prober efibootmgr networkmanager dhcpcd netctl wpa_supplicant dialog
echo "GENERAR FSTAB"
genfstab /mnt
genfstab /mnt >> /mnt/etc/fstab
echo "ENTRAR EN CHROOT"
cat > /mnt/chroot.txt << EOF
echo "CONFIGURACION RAPIDA"
ln -sf /usr/share/zoneinfo/Mexico/General /etc/localtime
hwclock -w
echo "huevos" > /etc/hostname
echo "GENERAR LOCALES"
echo "es_MX.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "NUEVA CONTRASEÑA PARA EL ADMINISTRADOR DEL EQUIPO"
passwd
echo "INSTALANDO EL GESTOR DE ARRANQUE, NO LE MUEVA CABRON"
grub-install --target=x86_64-efi --efi-directory=/boot
grub-install --target=x86_64-efi --efi-directory=/boot --removable
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
echo "ACTIVAR SERVICIOS ESCENCIALES"
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable gdm
echo "TERMINADO, ADIOS :-)"
EOF
chmod +x /mnt/chroot.txt
arch-chroot /mnt /chroot.txt
rm -rf /mnt/chroot.txt romanos-arch-installer
echo "Ejecuta reboot -n para reiniciar o poweroff -n para apagar"
exit
