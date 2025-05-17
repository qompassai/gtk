#!/bin/bash
# ~/.GH/Qompass/gtk/auto-extract.sh
# ---------------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
SLOG="install-$(date +%d-%H%M%S)_themes.log"
extract_files() {
    local source_dir="$1"
    local destination="$2"
    local extraction_type="$3"
    if [ -d "$source_dir" ]; then
        echo "Extracting files from '$source_dir' directory to '$destination'..."
        if [ "$extraction_type" == "tar" ]; then
            for file in "$source_dir"/*.tar.gz; do
                if [ -f "$file" ]; then
                    echo "Extracting $file to $destination..."
                    tar -xzf "$file" -C "$destination" --overwrite && echo "$OK Extracted $file to $destination" || echo "$ERROR Extraction of $file failed"
                fi
            done
        elif [ "$extraction_type" == "unzip" ]; then
            for file in "$source_dir"/*.zip; do
                if [ -f "$file" ]; then
                    echo "Extracting $file to $destination..."
                    unzip -o -q "$file" -d "$destination" && echo "$OK Extracted $file to $destination" || echo "$ERROR Extraction of $file failed"
                fi
            done
        else
            echo "${ERROR} Invalid extraction type '$extraction_type'."
            return 1
        fi
        echo "$OK Extraction from '$source_dir' directory completed"
    else
        echo "${ERROR} Source directory '$source_dir' does not exist."
        return 1
    fi
}
mkdir -p ~/.icons
mkdir -p ~/.themes
extract_files "theme" ~/.themes "tar" 2>&1 | tee -a "$SLOG"
extract_files "icon" ~/.icons "unzip" 2>&1 | tee -a "$SLOG"
