#!/bin/bash

# Arrays of fake values
albums=(
"NeonWorld" "SyntheticSouls" "DreamMaze" "AstralWaves" "EchoSystem"
"Midnight Circuits" "Quantum Mirage" "Electric Dusk" "NeuroNova" "RetroGrid"
"Cyber Horizon" "Infinity Loop" "Night Wavelength" "Digital Sunset" "Celestial Bloom"
"Pixel Dreams" "Electric Aurora" "Signal Veil" "Neon Static" "Glitch Realm"
"Skytrace" "Nova Mirage" "Data Mirage" "Hologram Highways" "Electric Spiral"
"Pulsewave Diaries" "Dreamframe" "Future Drift" "Astral Prism" "Lunar Bloom"
"Chrome Dreams" "Zero Gravity Sound" "Vapor Street" "Subspace Echoes" "Dusk Circuitry"
"Stellar Memory" "Digital Haze" "Hyperlight Chase" "Polychrome Veins" "Retro Pulse"
"Midnight Mirage" "Cyber Lotus" "Solar Tunnels" "Arcade Skyline" "Neon Realm"
"Twilight Phase" "Nightgrid" "Parallel Future" "Eclipse Station" "Electric Mirage"
)

artists=(
"DJ Phantom" "The Voidwalkers" "NovaPulse" "Aurora Drive" "PixelVerse"
"CyberNomad" "Echo Driver" "Future Prophet" "ZeroSignal" "Digital Bloom"
"LunarGhost" "Nightshifter" "Retro Nova" "Midnight Reactor" "Signal Seeker"
"Neon Wanderer" "Shadow Circuit" "Arcade Prophet" "Bass Prism" "Quantum Sirens"
"Sonic Mirage" "Starlight Runner" "Voltage Ghost" "Dream Architect" "Pixel Rider"
"Virtual Flame" "Darkbyte" "Astro Hacker" "Memory Encoder" "Fractal Agent"
"Chrono Pulse" "Digital Monk" "Phase Blazer" "The Synth Society" "Cassette Prophet"
"Sky Chaser" "Gridmancer" "Turbo Aura" "Echo Shade" "Zero Drift"
"NightDrive Twins" "VaporAgent" "Neon Sentinel" "The Fadeout" "Loop Star"
"HyperSilk" "Time Capsule" "Binary Ghost" "Cyber Ritual" "Electric Monk"
)

titles=(
"Binary Love" "Chrome Horizon" "Signal Fade" "Crystal Path" "Moon Sync"
"Darkline" "Lunar Fade" "DataFlow" "Orbit Rush" "Neon Pulse"
"Circuit Bloom" "Stellar Drift" "Pixel Dancer" "Nightcode" "Echo Trace"
"Static Dreams" "Glitchwave" "Neon Rain" "Voidwalk" "Data Kiss"
"Photon Dust" "Holo Memory" "Gravity Loop" "Midnight Codes" "Backtrack Dreams"
"Laser Shore" "Infinity Spin" "Pulse Engine" "Electric Eden" "The Fadeout"
"Cloud Chaser" "Analog Ghost" "Cosmic Circuit" "Dreamlight" "Lost in Frequency"
"Gamma Tunnel" "Synthetic Moonlight" "Phase Runners" "Visions in Neon" "Hypernova Beat"
"Zero Sync" "Cosmo Bloom" "Prism Rain" "Ultraviolet Rush" "Aurora Seeker"
"Retrowave Heart" "Quantum Loop" "Electric Sanctuary" "Night Commute" "Cyber Halo"
)

genres=(
"Synthwave" "Cyberpop" "Retrowave" "Space Jazz" "Dreamstep"
"Futurecore" "Astral Funk" "Glitchhop" "Darkwave" "Neocircuit"
"Vaporwave" "Chillwave" "Outrun" "Electrofunk" "Neo-Disco"
"Technoir" "Cosmic Chill" "Dreamwave" "Cyber Funk" "Datastep"
"Electro Lounge" "Lofi Tron" "Arcade Funk" "Postwave" "Ultrasynth"
"Neon Fusion" "Retro Synthpop" "Hologram House" "Circuit Pop" "Virtual Soul"
"Galaxy Funk" "Electronova" "Hyperpopwave" "Bitbeat" "Retrolounge"
"Cloudtronica" "Digital Chill" "Nightbeat" "Starwave" "Chromawave"
"Futuresoul" "Glamtronica" "Phase Pop" "Pixelwave" "Shadow Pop"
"Cyber Samba" "Dreamhop" "Echo Groove" "Neofunk" "Sunset Tech"
)

# Target folder for audio files
AUDIO_DIR="dst_audio"

# Loop through all MP3 files in the target folder
for file in "$AUDIO_DIR"/*.mp3; do
    [ -e "$file" ] || continue

    # Pick random metadata values
    album="${albums[$RANDOM % ${#albums[@]}]}"
    artist="${artists[$RANDOM % ${#artists[@]}]}"
    title="${titles[$RANDOM % ${#titles[@]}]}"
    genre="${genres[$RANDOM % ${#genres[@]}]}"
    year=$((RANDOM % 24 + 2000))
    track=$((RANDOM % 20 + 1))
    disc=$((RANDOM % 5 + 1))

    # Temp output file
    tmpfile="${file%.mp3}_tmp.mp3"

    # Update metadata using ffmpeg
    ffmpeg -y -i "$file" \
        -metadata title="$title" \
        -metadata artist="$artist" \
        -metadata album="$album" \
        -metadata genre="$genre" \
        -metadata date="$year" \
        -metadata track="$track" \
        -metadata disc="$disc" \
        -codec copy "$tmpfile"

    # Replace original file
    mv "$tmpfile" "$file"
    echo "Updated metadata for: $file"
done