#!/usr/bin/env bash
# Checks each external form in data/destinations.yaml online. Run it with
# `make check-destinations`; it is not part of `make check` or CI, so an
# outage at Wufoo or Breeze never blocks a deploy.
#
# For each entry it prints the form's page title and fails (exit 1) when:
#   - the URL can't be reached or doesn't return 200 (a missing Wufoo form
#     returns 404);
#   - a Breeze page's title is "Form": Breeze returns 200 with that title
#     for a form that doesn't exist;
#   - the entry is open on the site but the Wufoo form is closed.
# It notes, without failing, a form that accepts entries while the site
# shows it closed (normal while a new form is prepared), and an entry with
# no url.
#
# The file is read with awk, so it must keep its documented shape: a
# top-level name, then indented open, label, url, and closedText fields.

set -u

file="${1:-data/destinations.yaml}"
status=0
count=0

# One "name<TAB>open<TAB>url" line per entry.
entries=$(awk '
  function flush() { if (name != "") print name "\t" open "\t" url }
  /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
  /^[A-Za-z][A-Za-z0-9_]*:/ {
    flush()
    name = $0; sub(/:.*/, "", name); open = "false"; url = ""
    next
  }
  /^[[:space:]]+open:/ {
    open = ($0 ~ /open:[[:space:]]*true/) ? "true" : "false"
  }
  /^[[:space:]]+url:/ {
    url = $0; sub(/^[[:space:]]+url:[[:space:]]*"?/, "", url); sub(/".*/, "", url)
    sub(/[[:space:]]+#.*/, "", url); sub(/[[:space:]]+$/, "", url)
  }
  END { flush() }
' "$file") || { echo "FAIL  could not read $file"; exit 1; }

while IFS=$'\t' read -r name open url; do
  [ -n "$name" ] || continue
  count=$((count + 1))
  site=$([ "$open" = true ] && echo open || echo closed)

  if [ -z "$url" ]; then
    printf 'NOTE  %-20s site: %-6s  no url\n' "$name" "$site"
    continue
  fi

  response=$(curl -sSL --max-time 20 -w '\n%{http_code}' "$url" 2>&1)
  code=${response##*$'\n'}
  body=${response%$'\n'*}
  title=$(printf '%s' "$body" | tr '\n' ' ' | grep -oiE '<title[^>]*>[^<]*</title>' | head -n 1 |
    sed -E 's/<[^>]*>//g; s/^[[:space:]]+//; s/[[:space:]]+$//')

  if [ "$code" != 200 ]; then
    printf 'FAIL  %-20s HTTP %s  %s\n' "$name" "$code" "$url"
    status=1
    continue
  fi
  if [[ "$url" == *breezechms.com* && "$title" == "Form" ]]; then
    printf 'FAIL  %-20s Breeze form not found  %s\n' "$name" "$url"
    status=1
    continue
  fi

  form=open
  if printf '%s' "$body" | grep -qi 'no longer accepting submissions'; then
    form=closed
  fi

  if [ "$site" = open ] && [ "$form" = closed ]; then
    printf 'FAIL  %-20s site: open    form: closed  %s\n' "$name" "$title"
    status=1
  elif [ "$site" = closed ] && [ "$form" = open ] && [[ "$url" == *wufoo.com* ]]; then
    printf 'NOTE  %-20s site: closed  form: open    %s\n' "$name" "$title"
  else
    printf 'OK    %-20s site: %-6s  form: %-6s  %s\n' "$name" "$site" "$form" "$title"
  fi
done <<< "$entries"

if [ "$count" -eq 0 ]; then
  echo "FAIL  no entries found in $file"
  status=1
fi

exit $status
