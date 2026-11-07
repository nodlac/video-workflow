# Acceptance checklist

- Confirm Seagate extended SMART test and inspect existing partitions before formatting.
- Verify intended mounts on Callisto; test behavior with missing archive/DAS.
- Create restricted SSH keys/account and verify host key fingerprints.
- Stop OBS recording; ensure one complete upload with matching SHA-256 and correct project.
- Interrupt network mid-upload; retry safely without a falsely complete file.
- Ensure same-name recordings cannot overwrite.
- Pull twice on Behemoth and confirm second pull does not recopy unchanged files.
- Push an editing snapshot, restore it to a different directory, and compare files.
- Archive finished video, verify checksum, then restore it.
- Test backup/restore of actual server settings and database dumps.
- Only after all above: design quarantined, reversible cleanup with verification and manual approval.
