#!/bin/bash

# === CONFIGURATION ===
audio_dir="./dst_audio"
video_dir="./dst_video"
output_dir="./dst_audio_and_video_playlists"

mkdir -p "$output_dir"

# Collect all .mp3 files from dst_audio
media_files=()
while IFS= read -r -d $'\0' file; do
  media_files+=("$file")
done < <(find "$audio_dir" -type f -name "*.mp3" -print0)

# Collect all .mp4 files from dst_video
while IFS= read -r -d $'\0' file; do
  media_files+=("$file")
done < <(find "$video_dir" -type f -name "*.mp4" -print0)

# Exit if no media files found
if [[ ${#media_files[@]} -eq 0 ]]; then
  echo "❌ No MP3 or MP4 files found."
  exit 1
fi

total_files=${#media_files[@]}

# Playlist names
playlist_names=(
  "Top Hits" "Workout Vibes" "Chill Beats" "Morning Motivation" "Evening Relaxation"
  "Focus Mode" "Late Night" "Party Time" "Indie Mix" "Rock On"
  "Hip Hop Essentials" "Electronic Waves" "Jazz Corner" "Blues Session" "Acoustic Afternoon"
  "Throwback" "Summer Sounds" "Winter Chill" "Road Trip" "Study Sounds"
  "Meditation" "Coffeehouse" "Feel Good" "Melancholy Mix" "Dancefloor"
  "Romantic Tunes" "Epic Soundscapes" "Happy Hours" "Instrumental Gems" "Deep Vibes"
)

# Function to return a shuffled copy of media_files
get_shuffled_copy() {
  printf "%s\n" "${media_files[@]}" | awk 'BEGIN{srand()} {print rand(), $0}' | sort -k1,1n | cut -d' ' -f2-
}

# Generate playlists
for name in "${playlist_names[@]}"; do
  playlist="${output_dir}/${name}.m3u8"
  echo "#EXTM3U" > "$playlist"

  # Random track count between 10 and total media files
  track_count=$((10 + RANDOM % (total_files - 9)))

  count=0
  get_shuffled_copy | while IFS= read -r file; do
    [[ $count -ge $track_count ]] && break

    artist="Unknown Artist"
    title="Unknown Title"
    duration="0"

    # Try reading artist/title from file metadata
    while IFS='=' read -r key value; do
      case "$key" in
        TAG:artist) artist="$value" ;;
        TAG:title)  title="$value" ;;
      esac
    done < <(ffprobe -v quiet -show_entries format_tags=artist,title -of default=noprint_wrappers=1:nokey=0 "$file")

    # Get duration
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" | awk '{printf "%.0f", $1}')

    # Adjust relative path for playlist
    rel_path="../${file#./}"

    echo "#EXTINF:${duration},${artist} – ${title}" >> "$playlist"
    echo "$rel_path" >> "$playlist"

    count=$((count + 1))
  done
done

echo "✅ Created ${#playlist_names[@]} playlists in $output_dir"