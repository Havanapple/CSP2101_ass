#!/bin/bash

# Peter Whitehead
# 10466917

#Check that rectangle.txt exists in current directory
targetFile=rectangle.txt

while ! [ -f "$targetFile" ]; do    # While the targetFile does not exist, do this
    if ! [[ $targetFile = 'x' ]]; then        # Allow for exit option
        echo "Could not find $targetFile"
        read -p 'Please enter an alternate directory/file or press x to exit: ' targetFile     # Prompt for alternate directory/file
    else
        exit 0
    fi
done        
echo "Processing $targetFile..."     #Feedback for user

# Sed initialised.
# First line removes 1st line of document
# Second line aims at the beginning of each line with ^ and inserts 'Name: ' before the line characters
# Third to sixth line replaces the first commas of each line in turn with Width, Height, Area, and Colour labels
# The final line (sixth) defines the input and output files
sed -e '1d'\
    -e 's/^/Name: /g'\
    -e 's/,/\tWidth: /1'\
    -e 's/,/\tHeight: /1'\
    -e 's/,/\tArea: /1'\
    -e 's/,/\tColour: /1' $targetFile > rectangle_f.txt

# Commenting for the sed function needed to be done before or after the sed block, as inline commenting 
# seemed to mess with the backslash operation. Even commenting inbetween lines produced an error for some reason.

echo "Processing complete."  # Feedback for user
exit 0