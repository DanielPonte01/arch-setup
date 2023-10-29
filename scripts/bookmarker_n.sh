#!/bin/bash
BOOKMARKS_FILE="$HOME/Documents/bookmarks"
[ ! -f "$BOOKMARKS_FILE" ] && touch "$BOOKMARKS_FILE"
open_bookmark() {
    local alias="$1"
    local url=$(awk -v alias="$alias" '$2 == alias {print $1}' "$BOOKMARKS_FILE")
    if [ -n "$url" ]; then
        if [[ ! $url =~ ^https?:// ]]; then
            url="http://$url"
        fi
        xdg-open "$url" &
    else
        echo "Bookmark not found: $alias"
    fi
}
add_bookmark() {
    local alias=$(echo "" | dmenu -p "Enter alias for the new bookmark:")
    local url=$(echo "" | dmenu -p "Enter URL for the new bookmark:")
    if [ -n "$alias" ] && [ -n "$url" ]; then
        echo "$url $alias" >> "$BOOKMARKS_FILE"
        notify-send "Bookmark $alias added"
        echo "Bookmark added successfully: $alias"
    else
        echo "Invalid input. Bookmark not added."
    fi
}
bookmark_list=$(cut -d' ' -f2 "$BOOKMARKS_FILE" | sed '/^$/d'; echo "Add Bookmark")
selected=$(echo -e "$bookmark_list" | dmenu -i -p "Bookmarks:")
if [ -n "$selected" ] && [ "$selected" != "Add Bookmark" ]; then
    open_bookmark "$selected"
elif [ "$selected" == "Add Bookmark" ]; then
    add_bookmark
fi

