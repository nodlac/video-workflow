# Windows OBS

Record MKV files into Videos/OBS with unique timestamped names. Configure a restricted SSH account on Callisto using the SSH alias callisto-video, with its host key verified. Run select-project.ps1 before recording. Run watch-recordings.ps1 at login (after manual testing); it polls for stable, unlocked files and calls upload.ps1. The uploader copies to a .part path, checks remote SHA-256, then publishes the filename. It never deletes local files.

Important: this watcher is a heuristic rather than a native OBS recording-stop event. Test with actual OBS recordings. Existing unuploaded files are also picked up. Project changes while recordings wait to upload can misclassify them; a future OBS event bridge should bind the project at recording start. Failed partial uploads need manual review before retry.
