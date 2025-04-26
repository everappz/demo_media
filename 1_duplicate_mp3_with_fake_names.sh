#!/bin/bash

# Updated paths
SOURCE_FILE="src_audio/demo.mp3"
DEST_DIR="dst_audio"

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Source file '$SOURCE_FILE' not found."
    exit 1
fi

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Expanded arrays of fake albums and track names (50 each)
albums=(
"MidnightEcho" "SunsetDrive" "LostHorizons" "NeonDreams" "RetroWaves"
"CrystalCity" "ElectricAurora" "NightVoyager" "FuturePast" "SynthEscape"
"Dreamscape" "UrbanLights" "TwilightZone" "PulseGrid" "EchoValley"
"LunarShift" "CyberGroove" "MoonBurn" "SkyRunner" "RadiantDust"
"PhotonTrail" "RetroStar" "StellarBeat" "ZeroPoint" "NovaFlash"
"SpaceWalk" "GravityRush" "StaticDream" "SonicPulse" "BlueMirage"
"HeatSignal" "NightSignal" "FutureRhythm" "PulseStorm" "CloudDrift"
"SunTracer" "GlowFade" "WarpDrive" "ParallelGlow" "Flashwave"
"NovaBound" "SilentOrbit" "DeepFrost" "SignalTheory" "EchoSphere"
"ChromeSky" "DarkLight" "FusionFrame" "ToneVector" "NeonBlaze"
)

tracks=(
"Starlight" "VelvetSkies" "DigitalRain" "ElectricHeart" "CrimsonMoon"
"NightCall" "PulseLine" "Skybound" "GhostSignal" "Echoes"
"TwilightDrive" "BlueDawn" "CyberShadows" "StaticWhispers" "LaserGlow"
"Radiowave" "OceanDust" "DreamSignal" "FrozenTime" "ShadowStep"
"MoonlightRush" "DarkMatter" "GlitchPulse" "NightVision" "RedNebula"
"Lumina" "PulseChamber" "ElectricVeins" "SunHalo" "OrbitFall"
"PhotonDrift" "DriftSignal" "MemoryTrace" "NightCircuit" "CodeBreaker"
"NeonRush" "SleepMode" "TimeFade" "Holograph" "PhaseLock"
"VaporCrush" "HeartDrive" "SignalBloom" "AstroShine" "BassField"
"GlowSpark" "ToneShadow" "NovaBeat" "DreamLoop" "FlashStep"
)

# Create 50 files with combinations
for i in {1..50}; do
    # Random album and track
    album="${albums[$RANDOM % ${#albums[@]}]}"
    track="${tracks[$RANDOM % ${#tracks[@]}]}"

    # Output filename
    filename="${album}_${track}.mp3"
    output_path="$DEST_DIR/$filename"

    # Ensure filename is unique
    if [ -f "$output_path" ]; then
        filename="${album}_${track}_$RANDOM.mp3"
        output_path="$DEST_DIR/$filename"
    fi

    # Copy the file
    cp "$SOURCE_FILE" "$output_path"
    echo "Created: $output_path"
done