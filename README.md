# demo_media

A toolkit to generate demo audio, metadata, artwork, and playlists automatically.  
Perfect for app demos, mockups, or media-related testing.

---

## Features

- 🎵 Duplicate a demo audio file and assign realistic random names
- 📝 Add fake metadata (title, artist, album, genre, year, etc.) to all MP3 files
- 🎨 Add random AI-generated artwork to each audio file
- 📽️ Automatically generate short demo videos from audio and images
- 📋 Create randomized `.m3u8` playlists for audio and videos
- 📂 Organized output folders: `dst_audio`, `dst_video`, and playlist folders
- 🛡️ Includes a [License](LICENSE.txt) granting full usage rights

---

## Folder Structure

```
src_audio/          # Source demo audio (demo.mp3)
src_img/            # Source images (for artwork)
dst_audio/          # Output audio files
dst_video/          # Output video files
dst_audio_playlists/         # Audio playlists
dst_audio_and_video_playlists/  # Mixed playlists
```

---

## Scripts

- **1_duplicate_mp3_with_fake_names.sh**  
  ➔ Create 50 audio copies with randomized album and track names.

- **2_set_fake_mp3_metadata.sh**  
  ➔ Set fake metadata (artist, title, album, genre, year, track, disc) for every file in `dst_audio/`.

- **3_add_random_artwork.sh**  
  ➔ Randomly assign an image from `src_img/` to each audio file as album artwork.

- **4_generate_videos.sh**  
  ➔ Create short demo videos from MP3 files and their cover images using FFmpeg.

- **5_generate_audio_playlists.sh**  
  ➔ Generate fun randomized audio playlists (.m3u8) from files in `dst_audio/`.

- **6_generate_audio_and_video_playlists.sh**  
  ➔ Generate mixed playlists from both audio and video files.

- **img_prompts.txt**  
  ➔ Collection of prompts used for generating source images.

---

## Requirements

- **bash**
- **ffmpeg**
- **awk** (preinstalled on macOS/Linux)
- **GNU find** (`find` command)

---

## Usage

1. Place your initial `demo.mp3` into `src_audio/`.
2. Place your image files into `src_img/`.
3. Run each script in order:

```bash
bash 1_duplicate_mp3_with_fake_names.sh
bash 2_set_fake_mp3_metadata.sh
bash 3_add_random_artwork.sh
bash 4_generate_videos.sh
bash 5_generate_audio_playlists.sh
bash 6_generate_audio_and_video_playlists.sh
```

4. Check the generated outputs inside the corresponding folders.

---

## License

All generated content is free to use under the included [LICENSE](LICENSE.txt).

---

## Notes

- No real copyrighted material is used.
- All audio and visual assets are mock/demo creations.
- Great for testing music players, media libraries, playlist apps, and more!

---

Enjoy! 🚀