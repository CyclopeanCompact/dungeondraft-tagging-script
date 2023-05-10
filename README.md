# Dungeondraft Tagging Script

This is a Bash script for Linux to automatically generate tags for a Dungeondraft asset pack. I used to use EightBitz's Dungeondraft Tools, but it doesn't run on Wine for arcane and inexplicable reasons. I didn't need the unpacking/repacking tools, just the tag functions, so I made this to help me do it.

## Technical Description

This script can be placed in an unpacked asset pack's root directory (the folder containing the pack.json and preview image). It then scans the textures/objects directory, constructs a list of tags based on the subdirectories (i.e. Foliage/Wood/Dead/dead_branch_2.webp will create the Foliage, Wood, and Dead tags), assigns all PNG and WEBP files to those tags based on their location in the subdirectories (the dead_branch_2.webp file will be assigned to Foliage, Wood, and Dead), and then creates a JSON file named default.dungeondraft_tags in the /data folder where the script is located (i.e. the usual place where that file is found).

## Basic Explanation

1. Put the script into your asset folder's root folder (the one with the pack.json file).
2. Place your assets into subdirectories inside the /objects directory according to the tags you want to assign them.
3. Mark it executable and run it in terminal.
4. Wait until it's finished running.

## Mild Issues

* It slows down the more subdirectories/tags it has to check/add each asset to.
* Also, I didn't figure out how to get it to alphabetize the tags object inside the JSON file, but eeehhh I doubt that will matter.
* I tested it with spaces in folder file names and it worked fine. I'm not 100% certain if there are special characters that will break it, though.

## Download
* [First and likely only release](https://github.com/CyclopeanCompact/dungeondraft-tagging-script/releases/download/Full/generate_tags.sh)
* Or see the .sh file above, or the Releases in the side column.
