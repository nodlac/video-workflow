# Video workflow

Initial implementation for a three-machine educational-video production workflow. **Not production ready; no automatic deletion is enabled.**

- **Somnambulist** (Windows/OBS): choose a project with `somnambulist/select-project.ps1`; watch for completed recordings with `somnambulist/watch-recordings.ps1`; upload with `somnambulist/upload.ps1` using SFTP and SHA-256 verification. Uploads happen shortly after recording stops, subject to the watcher detecting a stable, unlocked file.
- **Callisto** (Ubuntu): stable storage paths under `/srv/video`, independent of physical disk. Finished exports copied to separately mounted Seagate at `/srv/video-archive` with `callisto/archive-finished.sh`.
- **Behemoth** (Linux): `behemoth/pull.sh` retrieves recordings, `behemoth/snapshot.sh` uploads versioned editing snapshots, `behemoth/cleanup-candidates.sh` lists old local projects without deleting them.

See [architecture and retention](docs/architecture.md), [acceptance checks](docs/acceptance.md), and machine setup docs: [Somnambulist](docs/somnambulist.md), [Behemoth](docs/behemoth.md), [Callisto](docs/callisto.md).

## Proposed retention (not implemented)

- Behemoth editing cache: 30 days, with ability to pull files again.
- Callisto finished exports: 90 days after publication.
- Seagate published exports: about 2 years, reviewed before expiration.
- Server settings: encrypted Restic snapshots, after actual app/database paths are inventoried.

## Before deployment

Confirm Seagate health and filesystem, SSH credentials, storage mounts, and all end-to-end transfer/recovery checks. **Never enable deletion before verified copies and a restore test.** The archive becomes the only local copy of older exports if Callisto removes them; an additional independent copy is needed for important videos.

The repo was reported **public** when first checked. Never commit client recordings, passwords, private keys, or sensitive configurations.

## Current limitations

The OBS watcher is a polling-based first pass, not an OBS-native event hook. It can misassign a recording if the selected project changes while a file is waiting to upload. Interrupted uploads leave `.part` files requiring review. Editing snapshot restoration, automated server backup, full archive checksum audit, scheduling, and safe retention enforcement remain unfinished. This is code for testing, not an installed service.
