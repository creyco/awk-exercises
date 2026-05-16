#!/bin/bash

# Parameters to remove (tracking and analytics)
TRACKING_PARAMS="fbclid|gclid|utm_source|utm_medium|utm_campaign|utm_term|utm_content|yclid|_ga|mc_cid|mc_eid|ref|ref_src|ref_url|referrer|source"

INPUT="bookmarks.html"
OUTPUT="urls_limpias.txt"

# Extract URLs, normalize, remove duplicates
grep -oP 'HREF="[^"]+"' "$INPUT" | \
  sed 's/HREF="//;s/"$//' | \
  sed -E "s/($TRACKING_PARAMS)=[^&]*&?//g" | \
  sed -E 's/&+$//' | \
  sed -E 's/\?$//' | \
  grep -E '^https?://' | \
  sort -u > "$OUTPUT"

echo "$(wc -l < "$OUTPUT") URLs únicas guardadas en $OUTPUT"
