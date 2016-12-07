

##grub菜单添加密码


命令行执行 /sbin/grub-md5-crypt  产生密码

然后修改  
vim /etc/grub.conf
zai splashimage和title之间，
添加password --md5 ..生成的加密后的ｍｄ５值




    default=0
    timeout=5
    splashimage=(hd0,0)/grub/splash.xpm.gz
    hiddenmenu
    title CentOS (2.6.32-642.3.1.el6.x86_64)
    root (hd0,0)
    kernel /vmlinuz-2.6.32-642.3.1.el6.x86_64 ro root=UUID=d5a03e22-61ab-43b0-9cd7-ca9a5
    869205d rd_NO_LUKS rd_NO_LVM LANG=en_US.UTF-8 rd_NO_MD SYSFONT=latarcyrheb-sun16 crashkernel
    =auto  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet
    initrd /initramfs-2.6.32-642.3.1.el6.x86_64.img
    title CentOS 6 (2.6.32-573.el6.x86_64)
    root (hd0,0)
    kernel /vmlinuz-2.6.32-573.el6.x86_64 ro root=UUID=d5a03e22-61ab-43b0-9cd7-ca9a58692
    05d rd_NO_LUKS rd_NO_LVM LANG=en_US.UTF-8 rd_NO_MD SYSFONT=latarcyrheb-sun16 crashkernel=aut
    o  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet
    initrd /initramfs-2.6.32-573.el6.x86_64.img
