#!/bin/bash
browser="firefox"
default_engine="duckduckgo"
engine_key_ddg="ddg"
engine_key_youtube="yt"
engine_key_archwiki="arch"
engine_key_github="gh"
engine_key_alternativeto="alt"
input=$(echo "" | dmenu -p "Search: ")
if [[ -z "$input" ]]; then
    exit 0
fi
search_engine="${input%% *}"
search_term="${input#* }"
if [[ "$search_engine" == "$engine_key_ddg" ]]; then
    search_url="https://duckduckgo.com/?q=${search_term}"
elif [[ "$search_engine" == "$engine_key_youtube" ]]; then
    search_url="https://www.youtube.com/results?search_query=${search_term}"
elif [[ "$search_engine" == "$engine_key_archwiki" ]]; then
    search_url="https://wiki.archlinux.org/index.php?search=${search_term}"
elif [[ "$search_engine" == "$engine_key_github" ]]; then
    search_url="https://github.com/search?q=${search_term}"
elif [[ "$search_engine" == "$engine_key_alternativeto" ]]; then
    search_url="https://alternativeto.net/browse/search?q=${search_term}"
else
    search_url="https://duckduckgo.com/?q=${input}"
fi
$browser "$search_url" &
exit 0

