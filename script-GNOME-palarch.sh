echo "0.6.1"
echo ""
echo "Discos encontrados"
lsblk | grep "disk"
echo "Selecciona tu disco duro"
read disco
echo ""
echo "Creando particiones y volumenes en /dev/$disco ..."
echo ""
echo "YES" | parted /dev/$disco mklabel gpt
parted -a optimal /dev/$disco mkpart primary 1 fat32 1MiB 261MiB
parted set 1 esp on
parted -a optimal /dev/$disco mkpart primary 2 ext4 100%
echo "MONTAJE DE PARTICIONES"
mount /dev/$disco[2] /mnt
mkdir /mnt/boot
mount /dev/$disco[1] /mnt/boot
echo "DESCARGA DEL SISTEMA OPERATIVO..."
pacstrap /mnt base base-devel git wget curl linux linux-firmware grub os-prober efibootmgr networkmanager dhcpcd netctl wpa_supplicant dialog firefox libreoffice-fresh libreoffice-fresh-es hunspell-es_any hunspell-es_mx gnome wayland
echo "GENERAR FSTAB"
genfstab /mnt
genfstab /mnt >> /mnt/etc/fstab
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
echo "INSTALANDO EL GESTOR DE ARRANQUE"
grub-install --target=x86_64-efi --efi-directory=/boot
grub-install --target=x86_64-efi --efi-directory=/boot --removable
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
echo "ACTIVAR SERVICIOS ESCENCIALES"
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable gdm
EOF
chmod +x /mnt/chroot.txt
arch-chroot /mnt /chroot.txt
rm -rf /mnt/chroot.txt romanos-arch-installer
echo "TERMINADO, EJECUTA reboot -n PARA REINICIAR o poweroff -n PARA APAGAR"
exit
