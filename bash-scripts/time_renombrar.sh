#!/usr/bin/env bash
shopt -s nullglob
count=0

for f in *.jpg *.JPG; do
  # saltar si no es fichero regular
  [ -f "$f" ] || continue

  # calcular segundos totales y formatear mm-ss
  secs=$(( count * 2 ))
  mm=$(( secs / 60 ))
  ss=$(( secs % 60 ))
  label=$(printf "%02d-%02d" "$mm" "$ss")

  # construir nuevo nombre antes de la extensión
  base="${f%.*}"
  ext="${f##*.}"
  new="${base}_${label}.${ext}"

  # evitar sobrescribir: si existe, añade sufijo incremental
  if [ -e "$new" ]; then
    i=1
    while [ -e "${base}_${label}_$i.${ext}" ]; do
      ((i++))
    done
    new="${base}_${label}_$i.${ext}"
  fi

  mv -- "$f" "$new"
  echo "Renombrado: $f -> $new"
  ((count++))
done

