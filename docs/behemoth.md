# Behemoth

Copy config/behemoth.env.example to ~/.config/video-workflow/behemoth.env and edit it. Use SSH keys to a restricted Callisto account.

Run bash behemoth/pull.sh PROJECT to download recordings, bash behemoth/snapshot.sh PROJECT to send editing assets to a timestamped Callisto snapshot, and bash behemoth/cleanup-candidates.sh to view folders older than 30 days. Cleanup is read-only. Verify a restore before considering deletion.
