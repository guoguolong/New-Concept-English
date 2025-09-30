#!/bin/bash

seq=1
mkdir -p md
echo "# 新概念英语第${seq}册字幕集合" > md/book${seq}.md

# Process each LRC file
for file in 新概念英语第${seq}册美音（MP3+LRC）/NCE${seq}-美音-\(MP3+LRC\)/*.lrc; do
    # Extract filename without extension and path
    filename=$(basename "$file" .lrc)
    # Add lesson title
    echo -e "\n## $filename\n" >> md/book${seq}.md
    
    # Extract content, skip metadata lines and timestamps, and format sentences
    # Remove metadata and timestamps
    cat "$file" | grep -v '^\[al:\|^\[ar:\|^\[ti:\|^\[by:' | 
    sed 's/\[[0-9:\.]*\]//g' | # Remove timestamps
    sed 's/^[[:space:]]*//g' | # Remove leading whitespace
    sed 's/[[:space:]]*$//g' | # Remove trailing whitespace
    sed '/^$/d' | # Remove empty lines
    tr '\n' ' ' | # Join all lines
    sed "s/^Lesson [0-9]\\+ //g" | # Remove "Lesson X" at start
    sed "s/^${filename#*－} //g" | # Remove lesson title at start
    sed 's/.*Listen to the tape then answer this question\.//' | # Remove "Listen to the tape..." and text before it
    sed 's/\([.!?]\) /\1\n/g' | # Split on sentence endings
    sed 's/^[[:space:]]*//g' | # Clean up leading spaces
    sed '/^$/d' | # Remove empty lines
    sed '/^#/!s/^/* /' >> md/book${seq}.md # Add asterisk to each line except headings
    
    # Add newline at end of section
    echo -e "\n" >> md/book${seq}.md
done
