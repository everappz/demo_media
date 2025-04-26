#!/bin/bash

# Absolute path of script directory
script_dir="$(cd "$(dirname "$0")" && pwd)"
photos_dir="$script_dir/src_img"
audio_dir="$script_dir/dst_audio"

# Check for ffmpeg
if ! command -v ffmpeg >/dev/null; then
  echo "❌ Error: ffmpeg not found. Please install ffmpeg."
  exit 1
fi

# Collect all .jpg and .png images into array
photo_files=()
while IFS= read -r -d '' file; do
  photo_files+=("$file")
done < <(find "$photos_dir" -type f \( -iname '*.jpg' -o -iname '*.png' \) -print0)

# Collect all .mp3 files in dst_audio directory
mp3_files=()
while IFS= read -r -d '' file; do
  mp3_files+=("$file")
done < <(find "$audio_dir" -maxdepth 1 -type f -iname '*.mp3' -print0)

# Check count
num_photos=${#photo_files[@]}
num_mp3s=${#mp3_files[@]}
if [ "$num_photos" -lt "$num_mp3s" ]; then
  echo "❌ Not enough images ($num_photos) for $num_mp3s MP3 files."
  exit 1
fi

# Shuffle photos
shuffled_photos=($(printf "%s\n" "${photo_files[@]}" | awk 'BEGIN{srand()}{print rand() "\t" $0}' | sort -k1,1 | cut -f2-))

# Process each MP3
index=0
for mp3_file in "${mp3_files[@]}"; do
  image_file="${shuffled_photos[$index]}"
  square_img="$script_dir/.temp_artwork_$index.jpg"
  output_file="${mp3_file%.mp3}_art.mp3"

  # Crop image to square
  ffmpeg -loglevel quiet -y -i "$image_file" -vf "crop='min(in_w\,in_h)'" "$square_img"

  # Embed artwork
  ffmpeg -loglevel quiet -y -i "$mp3_file" -i "$square_img" \
    -map 0:a -map 1 -c copy -id3v2_version 3 \
    -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" \
    "$output_file"

  mv "$output_file" "$mp3_file"
  echo "✅ Added artwork to: $(basename "$mp3_file")"

  index=$((index + 1))
done

# Cleanup
rm -f "$script_dir/.temp_artwork_"*.jpg