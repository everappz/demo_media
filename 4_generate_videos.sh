#!/bin/bash

script_dir="$(cd "$(dirname "$0")" && pwd)"
photos_dir="$script_dir/src_img"
audio_file="$script_dir/src_audio/demo.mp3"
output_dir="$script_dir/dst_video"

mkdir -p "$output_dir"

# Check dependencies
if ! command -v ffmpeg >/dev/null || ! command -v ffprobe >/dev/null; then
  echo "❌ Error: ffmpeg or ffprobe not found. Please install them first."
  exit 1
fi

if [ ! -f "$audio_file" ]; then
  echo "❌ Error: demo.mp3 not found in script directory."
  exit 1
fi

# Get audio duration in seconds
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio_file")
duration=${duration%.*}
if [ -z "$duration" ]; then
  echo "❌ Error: Unable to get audio duration."
  exit 1
fi

# Video resolutions
resolutions=("1920x1080" "1280x720" "1080x1080" "720x720" "854x480" "640x360" "640x640" "480x480" "3840x2160" "2560x1440")

# Metadata arrays
artists=("Echo Star" "Nova Tune" "Cyber Dusk" "Pixel Drift" "Neon Drive" "DJ Mirage" "Sound Prism" "Cloud Parade" "Skytracer" "Electro Bloom" "Waveform Flow" "Bass Bloom" "Dreamstack" "Vibe Vector" "Zenith Beat" "Arcade Tone" "Astral Loop" "Night Circuit" "Crystal Pulse" "Glitch Echo" "Retro Dusk" "Audio Mirage" "Moon Glider" "Deep Synth" "Horizon Glow" "Phase Drift" "Bitstream Boy" "Pulse Aura" "Chroma Flux" "Loop Spiral" "Electro Kite" "Beat Liner" "Cloud Fader" "Orbit Bloom" "Hyper Dream" "Lunar Fade" "Synth Tracer" "Aurora Drift" "Tempo Fire" "Sound Trek" "Digital Ray" "Bass Crystal" "Echo Signal" "Rift Slider" "Night Signal" "Retroshine" "Cyberflora" "Shimmer Flow" "Melody Grid" "Trackbliss")
titles=("Mirror Rain" "Neon Breath" "Future Fade" "Signal Wave" "Dreamscript" "Cloud Machine" "Echo Vision" "Crystal Frame" "Code Light" "Data Dream" "Shadow Loop" "Moonbite" "Grid Slide" "Pixel Symphony" "Lunar Code" "Tempo Shift" "Nova Stream" "Sky Reboot" "Fade Matrix" "Loop Signal" "Nightform" "Flash Sync" "Binary Dusk" "Sonic Bloom" "Quantum Beat" "Cosmic Flow" "Hypertrace" "Glitch Flow" "Digital Drift" "Retro Circuit" "Fade Memory" "Color Engine" "Audio Ghost" "Synth Space" "Echo Lab" "Sky Mirror" "Pulse Sky" "Bass Vector" "Sound Echo" "Vibe Reboot" "Dreamsight" "Rhythm Rain" "Bitlight" "Retro Bloom" "Sonic Horizon" "Cloud Flash" "Orbit Sound" "Night Pulse" "Color Noise" "Track Prism")
genres=("Synthwave" "Retrowave" "Futurepop" "Cyberbeat" "Dreamstep" "Chilltronica" "Neo Ambient" "Space Jazz" "Lo-Fi Future" "Electro Drift")
years=(2005 2008 2010 2012 2014 2016 2018 2019 2020 2021 2022 2023)

# Collect and sort 50 image paths (sorted to keep consistent index-based access)
photo_files=()
while IFS= read -r -d '' img; do
  photo_files+=("$img")
done < <(find "$photos_dir" -type f \( -iname '*.jpg' -o -iname '*.png' \) -print0 | sort -z)

if [ ${#photo_files[@]} -lt 50 ]; then
  echo "❌ Error: Need at least 50 images in $photos_dir"
  exit 1
fi

# Generate videos
for i in $(seq 0 49); do
  img="${photo_files[$i]}"
  title="${titles[$i]}"
  res="${resolutions[$((RANDOM % ${#resolutions[@]}))]}"
  width="${res%x*}"
  height="${res#*x}"

  artist="${artists[$((RANDOM % ${#artists[@]}))]}"
  genre="${genres[$((RANDOM % ${#genres[@]}))]}"
  year="${years[$((RANDOM % ${#years[@]}))]}"
  track=$((RANDOM % 20 + 1))

  output_file="$output_dir/${title// /_}.mp4"

  ffmpeg -loglevel error -y \
    -loop 1 -framerate 24 -i "$img" -i "$audio_file" \
    -vf "scale=${width}:${height}:force_original_aspect_ratio=decrease,pad=${width}:${height}:(ow-iw)/2:(oh-ih)/2,fps=24" \
    -c:v libx264 -profile:v high -pix_fmt yuv420p -movflags +faststart \
    -t "$duration" \
    -c:a aac -b:a 192k \
    -metadata title="$title" \
    -metadata artist="$artist" \
    -metadata genre="$genre" \
    -metadata date="$year" \
    -metadata track="$track" \
    "$output_file"

  echo "🎬 Created: $(basename "$output_file")"
done

echo "✅ All 50 unique videos generated with 24 fps and full metadata!"