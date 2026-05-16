#!/usr/bin/env bash
shopt -s nullglob
increment=2        # segundos a aumentar por archivo
start_secs=30      # primer archivo termina en 00:30
count=0

for f in $(ls -1v *.jpg *.JPG 2>/dev/null); do
  [ -f "$f" ] || continue

  secs=$(( start_secs + count * increment ))
  mm=$(( secs / 60 ))
  ss=$(( secs % 60 ))
  label=$(printf "%02d:%02d-%02d:%02d" 0 0 "$mm" "$ss")  # formato 00:00-mm:ss

  base="${f%.*}"
  ext="${f##*.}"

  # nuevo nombre: etiqueta + espacio opcional + nombre original
  new="${label}-${base}.${ext}"

  # evitar sobrescribir: añadir sufijo si ya existe
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

