#!/bin/bash
rsync -av --checksum --delete /home/vikeltor/ /tmp/backup/ > /var/log/rsync-backup.log 2>&1
if [ $? -eq 0 ]; then
    echo "[$(date)] Резервное копирование выполнено успешно" >> /var/log/rsync-backup.log
else
    echo "[$(date)] Резервное копирование не выполнено" >> /var/log/rsync-backup.log
fi
