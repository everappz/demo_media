#!/bin/bash

# === CONFIGURATION ===
input_dir="./dst_audio"
output_dir="./dst_audio_playlists"

mkdir -p "$output_dir"

# Find all MP3 files in dst_audio/
mp3_files=()
while IFS= read -r -d $'\0' file; do
  mp3_files+=("$file")
done < <(find "$input_dir" -type f -name "*.mp3" -print0)

# Exit if no MP3 files found
if [[ ${#mp3_files[@]} -eq 0 ]]; then
  echo "❌ No MP3 files found in $input_dir."
  exit 1
fi

total_files=${#mp3_files[@]}

# Playlist names
playlist_names=(
  "Top Hits" "Workout Vibes" "Chill Beats" "Morning Motivation" "Evening Relaxation"
  "Focus Mode" "Late Night" "Party Time" "Indie Mix" "Rock On"
  "Hip Hop Essentials" "Electronic Waves" "Jazz Corner" "Blues Session" "Acoustic Afternoon"
  "Throwback" "Summer Sounds" "Winter Chill" "Road Trip" "Study Sounds"
  "Meditation" "Coffeehouse" "Feel Good" "Melancholy Mix" "Dancefloor"
  "Romantic Tunes" "Epic Soundscapes" "Happy Hours" "Instrumental Gems" "Deep Vibes"
)

# Function to shuffle and return N entries from mp3_files[]
get_shuffled_slice() {
  local count=$1
  printf "%s\n" "${mp3_files[@]}" | awk 'BEGIN{srand()} {print rand(), $0}' | sort -k1,1n | cut -d' ' -f2- | head -n "$count"
}

# Generate playlists
for name in "${playlist_names[@]}"; do
  playlist="${output_dir}/${name}.m3u8"
  echo "#EXTM3U" > "$playlist"

  # Random number of tracks (between 10 and total files)
  track_count=$((10 + RANDOM % (total_files - 9)))

  get_shuffled_slice "$track_count" | while IFS= read -r file; do
    artist="Unknown Artist"
    title="Unknown Title"
    duration="0"

    # Extract artist and title from metadata
    while IFS='=' read -r key value; do
      case "$key" in
        TAG:artist) artist="$value" ;;
        TAG:title)  title="$value" ;;
      esac
    done < <(ffprobe -v quiet -show_entries format_tags=artist,title -of default=noprint_wrappers=1:nokey=0 "$file")

    # Get duration in seconds
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" | awk '{printf "%.0f", $1}')

    # Path relative to dst_audio_playlists folder
    rel_path="../${file#./}"

    echo "#EXTINF:${duration},${artist} – ${title}" >> "$playlist"
    echo "$rel_path" >> "$playlist"
  done
done

echo "✅ Created ${#playlist_names[@]} playlists in $output_dir"