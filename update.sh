#!/usr/bin/env sh

function update()
{
  local old="$1"
  local new="$2"

  echo "$old"
  echo "$new"
  mv "$old" $TMPFILE && mv "$new" "$old" && mv $TMPFILE "$new"
}


