# Architecture and retention

Somnambulist (Windows/OBS) records short segments, tags each with a project slug, and uploads after the recording file closes. Callisto stores immutable recordings in /srv/video/incoming/<project>/<date>/ and editing snapshots in /srv/video/project-snapshots/<project>/<timestamp>/. Behemoth pulls files for editing and uploads snapshots. Published final exports live in /srv/video/finished and are copied to a separately mounted Seagate archive at /srv/video-archive/videos.

Retention goals: Behemoth local working copies 30 days; Callisto finished exports 90 days after publication; Seagate published-video archive approximately two years. These are *proposed policies*, not enabled deletion rules. Archive expiration requires review. Raw footage cleanup requires verified copies. A sole Seagate archive is not a backup.

DAS expansion: clients always use Callisto's network address and /srv/video paths. Stop services, copy and checksum-verify files, change only the backing mount for /srv/video, then resume. Mount by UUID, never /dev/sdX. Refuse archive operations if the archive mount is absent. Server settings and application databases need separate encrypted, consistent backups; do not copy live databases blindly.

No live machines are configured by this repository. Never commit credentials, footage, or client information. The repository is currently public.
