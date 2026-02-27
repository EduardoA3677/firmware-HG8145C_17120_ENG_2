#! /bin/sh

if [ -f /mnt/jffs2/lastsysinfo.tar.gz ]; then
    tar -zxvf /mnt/jffs2/lastsysinfo.tar.gz -C /var
    cat /var/lastsysinfo
    rm -rf /var/lastsysinfo
fi

exit 0
