#!/usr/bin/env bash
shopt -s nullglob
increment=3        # segundos entre archivos
start_secs=0       # primer archivo termina en 00:00
count=0

# lista ordenada alfanumérica (cambia ls options si quieres otro orden)
for f in $(ls -1v *.jpg *.JPG 2>/dev/null); do
  [ -f "$f" ] || continue

  secs=$(( start_secs + count * increment ))
  # limitar a 00:00-00:30 máximo
  if [ "$secs" -gt 30 ]; then
    echo "Máximo 00:00-00:30 alcanzado; deteniendo."
    break
  fi

  mm=$(( secs / 60 ))
  ss=$(( secs % 60 ))
  label=$(printf "%02d:%02d-%02d:%02d" 0 0 "$mm" "$ss")  # 00:00-mm:ss

  base="${f%.*}"
  ext="${f##*.}"

  new="${label}-${base}.${ext}"

  if [ -e "$new" ]; then
    i=1
    while [ -e "${label}-${base}_$i.${ext}" ]; do
      ((i++))
    done
    new="${label}-${base}_$i.${ext}"
  fi

  mv -- "$f" "$new"
  echo "Renombrado: $f -> $new"
  ((count++))
done
