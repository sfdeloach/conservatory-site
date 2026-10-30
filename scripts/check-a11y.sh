#!/usr/bin/env bash
# Runs axe, through pa11y-ci, on every page in the built site's sitemap,
# at a desktop width (1280px) and a phone width (375px). Part of
# `make check` and CI; run it alone with `make check-a11y` after
# `make build`.
#
# It serves public/ on 127.0.0.1 with python3 for the length of the check,
# and swaps the sitemap URLs' scheme and host for that address, so it works
# whatever the baseURL. Settings are in .pa11yci.js. axe's "needs review"
# results (such as text over an image or a gradient, whose contrast axe
# can't measure) are warnings; every other issue fails the check (exit 2),
# at either width.
#
# CHECK_A11Y_PORT sets the port (default 8137).

set -u

port="${CHECK_A11Y_PORT:-8137}"
base="http://127.0.0.1:$port"

if [ ! -f public/sitemap.xml ]; then
  echo "check-a11y: public/sitemap.xml not found; run make build first" >&2
  exit 1
fi

python3 -m http.server "$port" --bind 127.0.0.1 --directory public \
  >/dev/null 2>&1 &
server=$!
trap 'kill "$server" 2>/dev/null' EXIT

for _ in $(seq 50); do
  curl -fs -o /dev/null "$base/sitemap.xml" && break
  sleep 0.2
done
if ! curl -fs -o /dev/null "$base/sitemap.xml"; then
  echo "check-a11y: the local server on port $port did not start" >&2
  exit 1
fi

status=0
for width in 1280 375; do
  echo "check-a11y: ${width}px wide"
  A11Y_WIDTH="$width" npx --no-install pa11y-ci --config .pa11yci.js \
    --sitemap "$base/sitemap.xml" \
    --sitemap-find '^https?://[^/]+' --sitemap-replace "$base"
  result=$?
  [ "$result" -gt "$status" ] && status=$result
done
exit "$status"
