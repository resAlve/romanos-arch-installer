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
exit
