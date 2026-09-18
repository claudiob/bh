#!/bin/sh
# Every icon this gem shows anywhere is rendered from icon.svg, so the Earl's hat is drawn
# once and the set cannot drift apart: the browser's, iOS', and the avatar GitHub and the
# social networks are given. Run it after editing icon.svg and commit what changes.
#
#   brew install librsvg imagemagick
set -e

png() { rsvg-convert -w "$1" -h "$1" "$3" -o "$2"; }

# iOS masks the home-screen icon itself, and every service showing an avatar crops it
# round, so those two are rendered square-cornered: a corner rounded twice reads as a
# mistake.
sed "s/rx='14'/rx='0'/" icon.svg > /tmp/bh-square.svg

png 180 apple-touch-icon.png /tmp/bh-square.svg

# One avatar for GitHub and for every social network that asks for a picture: each crops
# its own square, and 1024 is the largest any of them wants.
png 1024 avatar.png /tmp/bh-square.svg
png 96 favicon-96x96.png icon.svg
png 192 web-app-manifest-192x192.png icon.svg
png 512 web-app-manifest-512x512.png icon.svg

# One .ico holding three sizes, each a PNG inside it, which is what a browser reaches for
# when it has been given no <link> — and what Windows and older Safari prefer regardless.
for size in 16 32 48; do png "$size" "/tmp/bh-$size.png" icon.svg; done
magick /tmp/bh-16.png /tmp/bh-32.png /tmp/bh-48.png favicon.ico
