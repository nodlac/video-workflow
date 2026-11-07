# Callisto

Inspect lsblk -f and findmnt before creating/mounting paths. Do not format the Seagate until its contents and extended SMART test are reviewed. Use /srv/video as a stable video root, /srv/video-archive as a separately mounted Seagate volume. Mount by UUID. Use a restricted SFTP account with verified SSH host keys. Run archive-finished.sh manually only after configuring config/callisto.env.example. It refuses an absent archive mount and does not delete sources.

For server settings, plan encrypted Restic backups and consistent database dumps after inspecting actual Docker volumes/databases. A live database directory copy is not necessarily restorable.

DAS migration: stop transfers, copy and checksum-verify data, swap the underlying /srv/video mount, test permissions and missing-mount behavior, resume clients.
